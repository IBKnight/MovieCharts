// ImageAPIServiceRepository.swift
// Copyright © Эдуард Еленский. All rights reserved.

import Foundation

protocol ImageAPIServiceProtocol {
    func loadImage(url: URL, handler: @escaping HandlerImage)
}
