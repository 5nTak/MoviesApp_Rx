//
//  MainCollectionViewDataSource.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/21.
//

import UIKit

final class MainCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    // MARK: - Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MainViewCell",
            for: indexPath
        ) as? MainViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(index: indexPath.row)
        
        return cell
    }
    
    // MARK: - HeaderView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "MainCollectionHeaderView",
            for: indexPath
        ) as? MainCollectionHeaderView else {
            return UICollectionReusableView()
        }
        headerView.setTitle(title: "인기 순위")
        
        return headerView
    }
}
