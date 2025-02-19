import 'package:app/custom_scaffold.dart';
import 'package:app/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCart extends StatelessWidget {
  final String title;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MyCart({super.key, required this.title, required this.isDarkMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Cart',
      body: Container(
        color: Colors.white70,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartList(),
              ),
            ),
            const Divider(height: 4, color: Colors.black),
            _CartTotal(),
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.titleLarge;
    var cart = context.watch<CartModel>();

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.done),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            cart.remove(cart.items[index]);
          },
        ),
        title: Text(
          '${cart.items[index].name} - \$${cart.items[index].price}',
          style: itemNameStyle,
        ),
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle = Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 48);

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CartModel>(
              builder: (context, cart, child) => Text('\$${cart.totalPrice}', style: hugeStyle),
            ),
            const SizedBox(width: 24),
            FilledButton(
              onPressed: () {
                var cart = context.read<CartModel>();
                String itemList = cart.items.map((item) => '${item.name} - \$${item.price}').join(' + ');
                String message = itemList.isEmpty ? "Your cart is empty!" : "$itemList = Total \$${cart.totalPrice}";

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }
}
