//
//  MainCollectionViewDataSource.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/21.
//

import UIKit

final class MainCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
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
}
