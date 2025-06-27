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
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildCustomAppBar(),
              _buildQuickStatsCards(),
              _buildProfileInfoCard(),
              _buildAccountDetailsCard(),
              _buildShopGalleryCard(),
              _buildActionButtons(),
              SizedBox(height: 20),
            ],
          ),
        ),
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
          child: ElevatedButton.icon(
            onPressed: controller.isEditing.value ? controller.saveProfile : controller.toggleEditMode,
            icon: Icon(
              controller.isEditing.value ? Icons.save : Icons.edit,
              size: 16,
            ),
            label: Text(
              controller.isEditing.value ? 'Save' : 'Edit',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: controller.isEditing.value ? Color(0xFF51CF66) : Color(0xFF6C5CE7),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              'value': '85%',
              'icon': Icons.account_circle_outlined,
              'color': Color(0xFF6C5CE7),
            },
            {
              'title': 'Account Age',
              'value': '2 years',
              'icon': Icons.calendar_today_outlined,
              'color': Color(0xFF51CF66),
            },
            {
              'title': 'Last Login',
              'value': 'Today',
              'icon': Icons.access_time_outlined,
              'color': Color(0xFFFF9500),
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
                  color: Colors.grey.withOpacity(0.06),
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
                    color: (stats[index]['color'] as Color).withOpacity(0.1),
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
            color: Colors.grey.withOpacity(0.08),
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
                    color: Color(0xFF6C5CE7).withOpacity(0.1),
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
                            color: Color(0xFF6C5CE7).withOpacity(0.1),
                            border: Border.all(
                              color: Color(0xFF6C5CE7).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'R',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C5CE7),
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
                            () => controller.isEditing.value
                                ? buildStyledTextField(
                                    labelText: 'Shop Name',
                                    controller: TextEditingController(text: controller.shopName.value),
                                    hintText: 'Enter shop name',
                                    onChanged: (value) => controller.shopName.value = value,
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
                          Text(
                            controller.emailAddress.value,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF6C5CE7).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'ID: ${controller.shopId.value}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6C5CE7),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF51CF66).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF51CF66),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Active',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF51CF66),
                                      ),
                                    ),
                                  ],
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
                Divider(color: Colors.grey[200]),
                SizedBox(height: 16),
                _buildProfileFields(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileFields() {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoField(
                  'Email Address',
                  controller.emailAddress.value,
                  Icons.email_outlined,
                  controller.isEditing.value,
                  (value) => controller.emailAddress.value = value,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildInfoField(
                  'Phone Number',
                  controller.phoneNumber.value,
                  Icons.phone_outlined,
                  controller.isEditing.value,
                  (value) => controller.phoneNumber.value = value,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInfoField(
            'Shop Address',
            controller.shopAddress.value,
            Icons.location_on_outlined,
            controller.isEditing.value,
            (value) => controller.shopAddress.value = value,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoField(
                  'Near Landmark',
                  controller.nearLandmark.value,
                  Icons.place_outlined,
                  controller.isEditing.value,
                  (value) => controller.nearLandmark.value = value,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildInfoField(
                  'Pin Code',
                  controller.pinCode.value,
                  Icons.pin_drop_outlined,
                  controller.isEditing.value,
                  (value) => controller.pinCode.value = value,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildInfoField(
            'City, State',
            controller.city.value,
            Icons.location_city_outlined,
            controller.isEditing.value,
            (value) => controller.city.value = value,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(
    String label,
    String value,
    IconData icon,
    bool isEditable,
    Function(String)? onChanged,
  ) {
    final textController = TextEditingController(text: value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[500]),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        isEditable && onChanged != null
            ? buildStyledTextField(
                labelText: label,
                controller: textController,
                hintText: 'Enter $label',
                onChanged: onChanged,
              )
            : Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  value.isEmpty ? 'Not specified' : value,
                  style: TextStyle(
                    fontSize: 13,
                    color: value.isEmpty ? Colors.grey[400] : Colors.black87,
                  ),
                ),
              ),
      ],
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
            color: Colors.grey.withOpacity(0.08),
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
                    color: Color(0xFF6C5CE7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_circle_outlined,
                    color: Color(0xFF6C5CE7),
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
                Row(
                  children: [
                    Expanded(
                      child: _buildAccountDetailItem(
                        'Account Status',
                        controller.accountStatus.value,
                        Icons.check_circle_outline,
                        Color(0xFF51CF66),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildAccountDetailItem(
                        'Member Since',
                        controller.memberSince.value,
                        Icons.calendar_today_outlined,
                        Color(0xFF00BCD4),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildAccountDetailItem(
                        'Password Status',
                        controller.passwordStatus.value,
                        Icons.lock_outline,
                        Color(0xFFFF9500),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildAccountDetailItem(
                        'User ID',
                        controller.userId.value,
                        Icons.badge_outlined,
                        Color(0xFF8B7ED8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
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
            color: Colors.grey.withOpacity(0.08),
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
                    color: Color(0xFF6C5CE7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFF6C5CE7),
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
                Spacer(),
                TextButton.icon(
                  onPressed: controller.uploadImage,
                  icon: Icon(Icons.add_photo_alternate_outlined, size: 16),
                  label: Text('Add Image', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFF6C5CE7),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
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
                          size: 28,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add Image',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => controller.isEditing.value
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.cancelEdit,
                      icon: Icon(Icons.close, size: 16),
                      label: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.saveProfile,
                      icon: Icon(Icons.save, size: 16),
                      label: Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF51CF66),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.changePassword,
                      icon: Icon(Icons.lock_outline, size: 16),
                      label: Text('Change Password'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF9500),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.snackbar(
                          'Info',
                          'Logout functionality would be implemented here',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                        );
                      },
                      icon: Icon(Icons.logout, size: 16),
                      label: Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red.withOpacity(0.5)),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.red.withOpacity(0.05),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}