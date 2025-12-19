import '../../../../../models/device_product.dart';

/// Centralised device products list – easy to reuse or update
final List<DeviceProduct> deviceProductsData = [
  // Netmeds Devices Store
  DeviceProduct(
    name: 'AccuSure Simple Glucometer Kit',
    imageUrl:
    'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/assets/item/free/resize-w:180/2QfIb-rk8x-accu_chek_guide_glucometer_kit_with_free_10_strips_114122_0_2.jpg',
    originalPrice: '₹1,199.00',
    discountedPrice: '₹719.40',
    discountPercentage: '40% OFF',
    isSaved: false,
    category: 'store',
  ),
  DeviceProduct(
    name: 'Omron HEM 7120 Automatic Blood Pressure Monitor',
    imageUrl:
    'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/assets/item/free/resize-w:180/j9-qWpjI9t-dr_morepen_glucoone_blood_glucose_test_strips_pack_of_50s_bg03_58318_0_5.jpg',
    originalPrice: '₹2,350.00',
    discountedPrice: '₹1,645.00',
    discountPercentage: '30% OFF',
    isSaved: true,
    category: 'store',
  ),
  DeviceProduct( name: 'One Touch Select Plus Glucometer', imageUrl: 'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/assets/item/free/resize-w:180/jpWY8DWXjO-freestyle_libre_flash_glucose_monitoring_system_sensor_137106_0_3.jpg', originalPrice: '₹1,100.00', discountedPrice: '₹770.00', discountPercentage: '30% OFF', isSaved: false, category: 'glucose', ),
  DeviceProduct( name: 'Accu-Chek Instant Glucometer', imageUrl: 'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/assets/item/free/resize-w:180/SxyfAJuRA9-accu_chek_active_glucose_monitor_with_free_10_test_strips_33516_0_4.jpg', originalPrice: '₹1,299.00', discountedPrice: '₹909.30', discountPercentage: '30% OFF', isSaved: false, category: 'glucose', ),
  // Blood Pressure Monitors
  DeviceProduct( name: 'Omron HEM-7156 Upper Arm Blood Pressure Monitor', imageUrl: 'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/assets/item/free/resize-w:180/wDek6-uT-z-omron_blood_pressure_monitor_upper_arm_type_hem_7121j_in_115562_0_2.jpg', originalPrice: '₹3,500.00', discountedPrice: '₹2,450.00', discountPercentage: '30% OFF', isSaved: true, category: 'bp', ), DeviceProduct( name: 'Dr. Morepen BP-15 Blood Pressure Monitor', imageUrl: 'hhttps://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/assets/item/free/resize-w:180/nu5UiiN-wl-omron_automatic_blood_pressure_monitor_hem_8712_115563_0_1.jpg', originalPrice: '₹2,799.00', discountedPrice: '₹1,399.50', discountPercentage: '50% OFF', isSaved: false, category: 'bp', ),
  // Shop By Category items
  DeviceProduct( name: 'Foot support', imageUrl: 'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:84/theme-image-1712033727234.png?dpr=1', originalPrice: '', discountedPrice: '', discountPercentage: '', isSaved: false, category: 'category', ),
  DeviceProduct( name: 'Health Equipment', imageUrl: 'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:214/theme-image-1712033762141.png?dpr=1', originalPrice: '', discountedPrice: '', discountPercentage: '', isSaved: false, category: 'category', ), DeviceProduct( name: 'Neck support', imageUrl: 'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:84/theme-image-1712042935429.png?dpr=1', originalPrice: '', discountedPrice: '', discountPercentage: '', isSaved: false, category: 'category', ),
  DeviceProduct( name: 'Blood Pressure Monitors', imageUrl: 'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:84/theme-image-1712033748326.png?dpr=1', originalPrice: '', discountedPrice: '', discountPercentage: '', isSaved: false, category: 'category', ), DeviceProduct( name: 'Hot Bag', imageUrl: 'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:214/theme-image-1712033775606.png?dpr=1', originalPrice: '', discountedPrice: '', discountPercentage: '', isSaved: false, category: 'category', ),
  DeviceProduct( name: 'Wheelchair', imageUrl: 'https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/nmz/company/2/applications/65f562c1504a59a67f529ad4/theme/pictures/free/resize-w:214/theme-image-1712042953940.png?dpr=1', originalPrice: '', discountedPrice: '', discountPercentage: '', isSaved: false, category: 'category', ),
  // Orthopedic Support section
  DeviceProduct( name: 'Tynor Knee Cap', imageUrl: 'https://via.placeholder.com/150x120/FCE4EC/E91E63?text=Knee+Cap', originalPrice: '₹399.00', discountedPrice: '₹319.20', discountPercentage: '20% OFF', isSaved: false, category: 'orthopedic', ), DeviceProduct( name: 'Flamingo Lumbar Support', imageUrl: 'https://via.placeholder.com/150x120/E8F5E8/4CAF50?text=Lumbar', originalPrice: '₹850.00', discountedPrice: '₹637.50', discountPercentage: '25% OFF', isSaved: true, category: 'orthopedic', ),
  // Oximeters section
  DeviceProduct( name: 'BPL SmartOxy Finger Pulse Oximeter', imageUrl: 'https://via.placeholder.com/150x120/E3F2FD/1976D2?text=BPL+Oxy', originalPrice: '₹2,999.00', discountedPrice: '₹1,199.60', discountPercentage: '60% OFF', isSaved: false, category: 'oximeter', ), DeviceProduct( name: 'Dr. Trust USA Pulse Oximeter', imageUrl: 'https://via.placeholder.com/150x120/FFF3E0/FF9800?text=Dr+Trust', originalPrice: '₹3,500.00', discountedPrice: '₹1,155.00', discountPercentage: '67% OFF', isSaved: false, category: 'oximeter', ),
  // Search & Filter section
  DeviceProduct( name: 'AccuSure TD Thermometer', imageUrl: 'https://via.placeholder.com/150x120/F3E5F5/9C27B0?text=Thermometer', originalPrice: '₹399.00', discountedPrice: '₹199.50', discountPercentage: '50% OFF', isSaved: true, category: 'search', ), DeviceProduct( name: 'Omron MC 246 Thermometer', imageUrl: 'https://via.placeholder.com/150x120/E1F5FE/0277BD?text=Omron+MC', originalPrice: '₹1,190.00', discountedPrice: '₹714.00', discountPercentage: '40% OFF', isSaved: false, category: 'search', ),
  // Weighing Scale section
  DeviceProduct( name: 'Equinox Personal Weighing Scale', imageUrl: 'https://via.placeholder.com/150x120/FCE4EC/E91E63?text=Scale', originalPrice: '₹2,199.00', discountedPrice: '₹1,099.50', discountPercentage: '50% OFF', isSaved: false, category: 'scale', ), DeviceProduct( name: 'Dr. Trust Electronic Scale', imageUrl: 'https://via.placeholder.com/150x120/E8F5E8/4CAF50?text=Dr+Scale', originalPrice: '₹1,899.00', discountedPrice: '₹949.50', discountPercentage: '50% OFF', isSaved: true, category: 'scale', ),
];
