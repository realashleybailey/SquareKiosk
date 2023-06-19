//
//  siren.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 19/01/2022.
//

import AVFoundation

var player: AVAudioPlayer?

func playSound() -> AVAudioPlayer? {
	guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else { return nil }
	
	do {
		try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
		try AVAudioSession.sharedInstance().setActive(true)
		
		/* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
		player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
		
		/* iOS 10 and earlier require the following line:
		 player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
		
		guard let player = player else { return nil }
		
		player.play()
		
		return player
		
	} catch let error {
		print(error.localizedDescription)
	}
	
	return nil
}
