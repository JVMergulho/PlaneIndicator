//
//  Utilities.swift
//  FocusIndicator
//
//  Created by João Vitor Lima Mergulhão on 24/02/25.
//

import UIKit
import RealityKit

extension simd_float4x4 {
    var translation: SIMD3<Float> {
        return SIMD3(x: columns.3.x, y: columns.3.y, z: columns.3.z)
    }
    
    var forward: SIMD3<Float> {
        return SIMD3(x: -columns.2.x, y: -columns.2.y, z: -columns.2.z)
    }
}

func imageToURL(image: UIImage) -> URL? {
    // Salvar a imagem em um arquivo temporário
    guard let data = image.pngData() else { return nil }
    
    // Criar um caminho para o arquivo temporário
    let fileManager = FileManager.default
    let tempDirectory = fileManager.temporaryDirectory
    let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")
    
    do {
        // Escrever os dados da imagem no arquivo
        try data.write(to: fileURL)
        return fileURL
    } catch {
        print("Erro ao salvar imagem: \(error)")
        return nil
    }
}

@MainActor func imageToTexture(named name: String) -> TextureResource?{
    guard let image = UIImage(named: name) else {
        print("image not found")
        return nil
    }
    guard let imageURL = imageToURL(image: image) else { return nil}

    let texture = try! TextureResource.load(contentsOf: imageURL)
    
    return texture
}
