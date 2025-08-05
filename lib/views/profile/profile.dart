import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/profile/user_profile_controller.dart';
import 'package:smartbecho/utils/common_textfield.dart';
import 'package:smartbecho/utils/custom_appbar.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingWidget();
          } else if (controller.hasError.value) {
            return _buildErrorWidget();
          } else {
            return RefreshIndicator(
              onRefresh: controller.refreshProfile,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildCustomAppBar(),
                    _buildQuickStatsCards(),
                    _buildProfileInfoCard(),
                    _buildAccountDetailsCard(),
                    _buildShopGalleryCard(),
                    _buildSocialMediaCard(),
                    _buildActionButtons(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF6C5CE7)),
          SizedBox(height: 16),
          Text(
            'Loading Profile...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(
            'Failed to load profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.refreshProfile,
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return buildCustomAppBar(
      "My Profile",
      isdark: true,
      actionItem: Obx(
        () => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child:
              controller.isEditing.value
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.cancelEdit,
                        icon: Icon(Icons.close, size: 16),
                        label: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          elevation: 0,
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: controller.saveProfile,
                        icon: Icon(Icons.save, size: 16),
                        label: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF51CF66),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  )
                  : ElevatedButton.icon(
                    onPressed: controller.toggleEditMode,
                    icon: Icon(Icons.edit, size: 16),
                    label: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF6C5CE7),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 0,
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsCards() {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          final stats = [
            {
              'title': 'Profile Score',
              'value': '${controller.galleryImages.length * 20 + 20}%',
              'icon': Icons.account_circle_outlined,
              'color': Color(0xFF6C5CE7),
            },
            {
              'title': 'Member Since',
              'value':
                  controller.memberSince.value.isNotEmpty
                      ? controller.memberSince.value.split('/').last
                      : 'N/A',
              'icon': Icons.calendar_today_outlined,
              'color': Color(0xFF51CF66),
            },
            {
              'title': 'Status',
              'value': controller.accountStatus.value,
              'icon': Icons.check_circle_outlined,
              'color':
                  controller.accountStatus.value.toLowerCase() == 'active'
                      ? Color(0xFF51CF66)
                      : Color(0xFFFF9500),
            },
          ];

          return Container(
            width: 120,
            margin: EdgeInsets.only(right: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha:0.06),
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (stats[index]['color'] as Color).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    stats[index]['icon'] as IconData,
                    color: stats[index]['color'] as Color,
                    size: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  stats[index]['value'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  stats[index]['title'] as String,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfoCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C5CE7).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: Color(0xFF6C5CE7),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF6C5CE7).withValues(alpha:0.1),
                            border: Border.all(
                              color: Color(0xFF6C5CE7).withValues(alpha:0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Obx(
                              () => Text(
                                controller.profileInitials,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C5CE7),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Color(0xFF6C5CE7),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () =>
                                controller.isEditing.value
                                    ? buildStyledTextField(
                                      labelText: 'Shop Name',
                                      controller: TextEditingController(
                                        text: controller.shopName.value,
                                      ),
                                      hintText: 'Enter shop name',
                                      onChanged:
                                          (value) =>
                                              controller.shopName.value = value,
                                    )
                                    : Text(
                                      controller.shopName.value,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                          ),
                          SizedBox(height: 4),
                          Obx(
                            () => Text(
                              controller.emailAddress.value,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF6C5CE7).withValues(alpha:0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Obx(
                                  () => Text(
                                    'ID: ${controller.shopId.value}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6C5CE7),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF51CF66).withValues(alpha:0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.verified,
                                  color: Color(0xFF51CF66),
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Obx(
                  () =>
                      controller.isEditing.value
                          ? buildStyledTextField(
                            labelText: 'GST Number',
                            controller: TextEditingController(
                              text: controller.gstNumber.value,
                            ),
                            hintText: 'GST number...',
                            onChanged:
                                (value) => controller.gstNumber.value = value,
                          )
                          : Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Text(
                              controller.gstNumber.value.isEmpty
                                  ? 'No gst number available'
                                  : controller.gstNumber.value,
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    controller.gstNumber.value.isEmpty
                                        ? Colors.grey[500]
                                        : Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF51CF66).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_box_outlined,
                    color: Color(0xFF51CF66),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Account Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDetailRow(
                  Icons.phone_outlined,
                  'Phone Number',
                  controller.phoneNumber.value,
                  isEditable: true,
                  onChanged: (value) => controller.phoneNumber.value = value,
                ),
                SizedBox(height: 16),
                _buildDetailRow(
                  Icons.location_on_outlined,
                  'Shop Address',
                      controller.fullAddress,
                  isEditable: true,
                  onChanged: (value) => controller.shopAddress.value = value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    bool isEditable = false,
    Function(String)? onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: Colors.grey[600], size: 16),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Obx(
                () =>
                    controller.isEditing.value && isEditable
                        ? buildStyledTextField(
                          controller: TextEditingController(text: value),
                          labelText: 'Enter $label',
                          onChanged: onChanged,
                          hintText: "",
                        )
                        : Text(
                          value.isEmpty ? 'Not specified' : value,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                value.isEmpty
                                    ? Colors.grey[500]
                                    : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShopGalleryCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF9500).withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.photo_library_outlined,
                        color: Color(0xFFFF9500),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Shop Gallery',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Text(
                    '${controller.galleryImages.length}/10',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Obx(() {
              if (controller.galleryImages.isEmpty) {
                return Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add photos of your shop',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        TextButton(
                          onPressed: controller.addGalleryImage,
                          child: Text('Upload Photos'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount:
                    controller.galleryImages.length +
                    (controller.galleryImages.length < 10 ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.galleryImages.length) {
                    return GestureDetector(
                      onTap: controller.addGalleryImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Icon(Icons.add, color: Colors.grey[600]),
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      Image.network(
                        controller.galleryImages[index].imageUrl,

                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                           
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: Colors.grey.shade300,),
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => controller.removeGalleryImage(index),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF3B82F6).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.share_outlined,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Social Media Links',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSocialRow(
                  Icons.facebook,
                  'Facebook',
                  controller.facebookUrl.value,
                  Color(0xFF1877F2),
                  onChanged: (value) => controller.facebookUrl.value = value,
                ),
                SizedBox(height: 16),
                _buildSocialRow(
                  Icons.camera_alt,
                  'Instagram',
                  controller.instagramUrl.value,
                  Color(0xFFE4405F),
                  onChanged: (value) => controller.instagramUrl.value = value,
                ),
                SizedBox(height: 16),
                _buildSocialRow(
                  Icons.language,
                  'Website',
                  controller.websiteUrl.value,
                  Color(0xFF10B981),
                  onChanged: (value) => controller.websiteUrl.value = value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialRow(
    IconData icon,
    String platform,
    String url,
    Color color, {
    Function(String)? onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Obx(
            () =>
                controller.isEditing.value
                    ? buildStyledTextField(
                      controller: TextEditingController(text: url),
                      hintText: 'Enter $platform URL',
                      onChanged: onChanged,
                      labelText: "",
                    )
                    : Text(
                      url.isEmpty ? 'Not connected' : url,
                      style: TextStyle(
                        fontSize: 14,
                        color: url.isEmpty ? Colors.grey[500] : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
          ),
        ),
        if (!controller.isEditing.value && url.isNotEmpty)
          IconButton(
            onPressed: () => controller.openUrl(url),
            icon: Icon(Icons.open_in_new, size: 16, color: Colors.grey[600]),
            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.all(4),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.red[600],
              ),
              label: Text(
                'Delete Account',
                style: TextStyle(color: Colors.red[600]),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
