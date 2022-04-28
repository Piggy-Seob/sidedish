//
//  OrderingCollectionViewDataSource.swift
//  SideDishApp
//
//  Created by 김상혁 on 2022/04/18.
//

import UIKit

final class OrderingCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private var headers: [Category] = [Category.main,
                                       Category.soup,
                                       Category.side]
    
    private var menus: [Category: [Menu]] = [:]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: Constant.Identifier.sectionHeaderView,
            for: indexPath
        ) as? SectionHeaderView else { return UICollectionReusableView() }
        
        supplementaryView.setTitle(title: headers[indexPath.section].headerValue)
        supplementaryView.setSectionNumber(number: indexPath.section)
        return supplementaryView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.headers[section] {
        case .main:
            return menus[Category.main]?.count ?? 0
        case .soup:
            return menus[Category.soup]?.count ?? 0
        case .side:
            return menus[Category.side]?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Identifier.orderingViewCell, for: indexPath) as? OrderingCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch self.headers[indexPath.section] {
        case .main:
            return configure(cell: cell, menu: menus[Category.main]?[indexPath.row])
        case .soup:
            return configure(cell: cell, menu: menus[Category.soup]?[indexPath.row])
        case .side:
            return configure(cell: cell, menu: menus[Category.side]?[indexPath.row])
        }
    }
    
    private func configure(cell: OrderingCollectionViewCell, menu: Menu?) -> OrderingCollectionViewCell {
        guard let dish = menu else { return OrderingCollectionViewCell() }
        cell.setDishImage(by: dish.image)
        cell.menuStackView.setTitle(by: dish.title)
        cell.menuStackView.setDescription(by: dish.description)
        cell.menuStackView.setPrice(originPrice: dish.n_price, discountedPrice: dish.s_price)
        cell.menuStackView.setBadges(by: dish.badge)
        return cell
    }
    
    func fetch(menus: [Menu], category: Category) {
        self.menus[category] = menus
    }
    
    func getSelectedItem(at index: IndexPath) -> Menu? {
        switch self.headers[index.section] {
        case .main:
            return menus[Category.main]?[index.row]
        case .soup:
            return menus[Category.soup]?[index.row]
        case .side:
            return menus[Category.side]?[index.row]
        }
    }
}
