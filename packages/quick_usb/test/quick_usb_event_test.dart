import 'package:flutter_test/flutter_test.dart';
import 'package:quick_usb/quick_usb.dart';

void main() {
  group('UsbDeviceEventType', () {
    test('values have correct names', () {
      expect(UsbDeviceEventType.attached.name, 'attached');
      expect(UsbDeviceEventType.detached.name, 'detached');
    });

    test('values.byName returns correct value for valid names', () {
      expect(UsbDeviceEventType.values.byName('attached'),
          UsbDeviceEventType.attached);
      expect(UsbDeviceEventType.values.byName('detached'),
          UsbDeviceEventType.detached);
    });

    test('values.byName throws ArgumentError for invalid name', () {
      expect(
        () => UsbDeviceEventType.values.byName('unknown'),
        throwsArgumentError,
      );
    });
  });

  group('UsbDeviceEvent', () {
    test('fromMap and toMap roundtrip for attached event', () {
      final original = UsbDeviceEvent(
        type: UsbDeviceEventType.attached,
        device: UsbDevice(
          identifier: '/dev/bus/usb/001/002',
          vendorId: 0x1234,
          productId: 0x5678,
          configurationCount: 1,
        ),
      );

      final restored = UsbDeviceEvent.fromMap(original.toMap());

      expect(restored.type, UsbDeviceEventType.attached);
      expect(restored.device.identifier, '/dev/bus/usb/001/002');
      expect(restored.device.vendorId, 0x1234);
      expect(restored.device.productId, 0x5678);
      expect(restored.device.configurationCount, 1);
    });

    test('fromMap and toMap roundtrip for detached event', () {
      final original = UsbDeviceEvent(
        type: UsbDeviceEventType.detached,
        device: UsbDevice(
          identifier: '2',
          vendorId: 0x0403,
          productId: 0x6001,
          configurationCount: 3,
        ),
      );

      final restored = UsbDeviceEvent.fromMap(original.toMap());

      expect(restored.type, UsbDeviceEventType.detached);
      expect(restored.device.vendorId, 0x0403);
      expect(restored.device.productId, 0x6001);
    });

    test('fromMap throws ArgumentError for invalid type string', () {
      final map = {
        'type': 'unknown',
        'device': {
          'identifier': '1',
          'vendorId': 1,
          'productId': 2,
          'configurationCount': 1,
        },
      };
      expect(() => UsbDeviceEvent.fromMap(map), throwsArgumentError);
    });

    test('toString contains type and device info', () {
      final event = UsbDeviceEvent(
        type: UsbDeviceEventType.attached,
        device: UsbDevice(
          identifier: 'test-dev',
          vendorId: 1,
          productId: 2,
          configurationCount: 1,
        ),
      );

      expect(event.toString(), contains('attached'));
      expect(event.toString(), contains('test-dev'));
    });
  });

  group('UsbDevice', () {
    test('fromMap and toMap roundtrip', () {
      final original = UsbDevice(
        identifier: '/dev/bus/usb/003/001',
        vendorId: 0xABCD,
        productId: 0xEF01,
        configurationCount: 2,
      );

      final restored = UsbDevice.fromMap(original.toMap());

      expect(restored.identifier, original.identifier);
      expect(restored.vendorId, original.vendorId);
      expect(restored.productId, original.productId);
      expect(restored.configurationCount, original.configurationCount);
    });
  });
}
