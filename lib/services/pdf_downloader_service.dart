import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFDownloadService {
  static final dio.Dio _dio = dio.Dio();

  /// Downloads a PDF file from the given URL and saves it to device storage
  static Future<void> downloadPDF({
    required String url,
    required String fileName,
    String? customPath,
    bool openAfterDownload = true,
    VoidCallback? onDownloadComplete,
  }) async {
    try {
      // Show initial loading snackbar
      Get.snackbar(
        'Download Started',
        'Downloading $fileName...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withValues(alpha:0.8),
        colorText: Colors.white,
        showProgressIndicator: true,
        duration: const Duration(seconds: 2),
      );

      // Check and request permissions
      bool hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        Get.snackbar(
          'Permission Denied',
          'Storage permission is required to download files',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha:0.8),
          colorText: Colors.white,
        );
        return;
      }

      // Get the directory to save the file
      String savePath = await _getSavePath(fileName, customPath);

      // Configure Dio options
      _dio.options.responseType = dio.ResponseType.bytes;
      _dio.options.followRedirects = true;
      _dio.options.validateStatus = (status) => status! < 500;

      // Download the file with progress tracking
     dio.Response response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total) * 100;
            print('Download progress: ${progress.toStringAsFixed(1)}%');
          }
        },
      );

      if (response.statusCode == 200) {
        // Success snackbar
        Get.snackbar(
          'Download Complete',
          '$fileName saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha:0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () => _openFile(savePath),
            child: const Text(
              'Open',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );

        // Open file automatically if requested
        if (openAfterDownload) {
          await _openFile(savePath);
        }

        // Call completion callback
        if (onDownloadComplete != null) {
          onDownloadComplete();
        }
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      _handleDownloadError('Network error: ${e.message}');
    } catch (e) {
      _handleDownloadError('Download failed: ${e.toString()}');
    }
  }

  /// Requests storage permission based on platform and API level
  static Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+)
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // Try to request manage external storage permission for Android 11+
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }

      // Fallback to legacy storage permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      return statuses[Permission.storage]?.isGranted ?? false;
    } else if (Platform.isIOS) {
      return true;
    }
    return false;
  }

  /// Gets the appropriate save path based on platform
  static Future<String> _getSavePath(String fileName, String? customPath) async {
    Directory? directory;

    if (Platform.isAndroid) {
      // Try to get Downloads directory first
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      throw Exception('Could not access storage directory');
    }

    // Create custom subdirectory if specified
    if (customPath != null) {
      directory = Directory('${directory.path}/$customPath');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    }

    return '${directory.path}/$fileName';
  }

  /// Opens the downloaded file
  static Future<void> _openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        print('Could not open file: ${result.message}');
      }
    } catch (e) {
      print('Error opening file: $e');
    }
  }

  /// Shows error snackbar
  static void _handleDownloadError(String message) {
    Get.snackbar(
      'Download Failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha:0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  /// Extracts filename from URL
  static String getFileNameFromUrl(String url) {
    try {
      Uri uri = Uri.parse(url);
      String path = uri.pathSegments.last;
      return path.isEmpty ? 'downloaded_file.pdf' : path;
    } catch (e) {
      return 'downloaded_file.pdf';
    }
  }

  /// Checks if file already exists
  static Future<bool> fileExists(String fileName, [String? customPath]) async {
    try {
      String filePath = await _getSavePath(fileName, customPath);
      return await File(filePath).exists();
    } catch (e) {
      return false;
    }
  }
}
