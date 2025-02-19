// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A proxy of the catalog of items the user can buy.
///
/// In a real app, this might be backed by a backend and cached on device.
/// In this sample app, the catalog is procedurally generated and infinite.
///
/// For simplicity, the catalog is expected to be immutable (no products are
/// expected to be added, removed or changed during the execution of the app).
class CatalogModel {
    static List<Map<String, dynamic>> items = [
    {'name': 'Maminha', 'price': 42, 'image': 'assets/images/maminha.jpeg'},
    {'name': 'Galinhas', 'price': 40, 'image': 'assets/images/galinhas.jpeg'},
    {'name': 'Ovos', 'price': 1, 'image': 'assets/images/ovos.jpeg'},
    {'name': 'Carneiro', 'price': 450, 'image': 'assets/images/carneiro.jpeg'},
    {'name': 'Bolo de milho', 'price': 25, 'image': 'assets/images/bolo_de_milho.jpeg'},
    {'name': 'Brownie', 'price': 8, 'image': 'assets/images/brownie.jpeg'},
    {'name': 'Banana', 'price': 4.5, 'image': 'assets/images/banana.jpeg'},
    {'name': 'Caju', 'price': 5, 'image': 'assets/images/caju.jpeg'},
    {'name': 'Acerola', 'price': 4, 'image': 'assets/images/acerola.jpeg'},
    {'name': 'Laranja', 'price': 6, 'image': 'assets/images/laranja.jpeg'},
    {'name': 'Castanha', 'price': 52, 'image': 'assets/images/castanha.jpeg'},
  ];

  /// Get item by [id].
  ///
  /// In this sample, the catalog is infinite, looping over [items].
  Item getById(int id) {
    final itemData = items[id % items.length];
    return Item(id, itemData['name'], itemData['price'],itemData['image']);
  }

  /// Get item by its position in the catalog.
  Item getByPosition(int position) {
    return getById(position);
  }
}

@immutable
class Item {
  final int id;
  final String name;
  final String image;
  final double price;

  Item(this.id, this.name, this.price, this.image);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
