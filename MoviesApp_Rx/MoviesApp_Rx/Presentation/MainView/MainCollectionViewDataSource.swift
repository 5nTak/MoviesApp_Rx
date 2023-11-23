//
//  MainCollectionViewDataSource.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/21.
//

import UIKit

final class MainCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
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
        guard let section = SectionLayoutKind(rawValue: indexPath.section),
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "MainCollectionHeaderView",
                for: indexPath
              ) as? MainCollectionHeaderView else {
            return UICollectionReusableView()
        }
        
        headerView.setTitle(title: section.description)

        return headerView
    }
}
