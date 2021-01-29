//
//  CellProtocol.swift
//  MyChat
//
//  Created by Иван Юшков on 26.01.2021.
//


protocol SelfConfiguringCell {
    static var reuseID: String { get }
    func configure<U: Hashable>(value: U)
}
