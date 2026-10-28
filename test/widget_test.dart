import 'package:flutter_test/flutter_test.dart';

import 'package:hindu_pay/main_shall.dart';

void main() {
  test('bottom bar stays visible only on top-level tab screens', () {
    expect(MainShell.shouldShowBottomBar('/main/home'), isTrue);
    expect(MainShell.shouldShowBottomBar('/main/donation'), isTrue);
    expect(MainShell.shouldShowBottomBar('/main/store'), isTrue);
    expect(MainShell.shouldShowBottomBar('/main/profile'), isTrue);

    expect(MainShell.shouldShowBottomBar('/main/store/cart'), isFalse);
    expect(MainShell.shouldShowBottomBar('/main/store/product/123'), isFalse);
    expect(MainShell.shouldShowBottomBar('/main/home/orders'), isFalse);
    expect(MainShell.shouldShowBottomBar('/donation/templeList'), isFalse);
  });
}
