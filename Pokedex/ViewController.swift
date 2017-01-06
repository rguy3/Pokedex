//
//  ViewController.swift
//  Pokedex
//
//  Created by Blu on 1/4/17.
//  Copyright © 2017 Blu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")! //Creating a path to get info
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!) //Take path and use audio player function
            musicPlayer.prepareToPlay() //Prep to play it
            musicPlayer.numberOfLoops = -1 //Play it over and over
            musicPlayer.play() //Start play
        } catch let err as Error { //If an error occurs, throw an error)
            print(err.localizedDescription)
        }
        }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")! //createspath to look for csv file
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
            
            print(rows)
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            if inSearchMode { //Sets if search filter is activated or not
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(pokemon: poke)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        } else {
            return pokemon.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true) //Hides keyboard after Search button is clicked
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" { //if search bar is empty
            inSearchMode = false //set searchmode to false
            view.endEditing(true) //If there's nothing, end editing, which clears keyboard
            collection.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil}) //$0 means an object, like pokemon[23] .. Range of lower means it'll go through all the words that contains whatever is on the search bar.  "filter" function is available to any array
            
            collection.reloadData() //refreshes view every time this function is played
        }
    }

    @IBAction func musicbuttonPressed(_ sender: UIButton!) {
        if musicPlayer.isPlaying == true {
            musicPlayer.stop()
            sender.alpha = 0.5 //Changes sender (button) to decrease opaqueness
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" { //if this is the identifier being called
            if let detailsVC = segue.destination as? PokemonDetailVC { //grab view controller
                if let poke = sender as? Pokemon { //if let sender item = Pokemon class
                    detailsVC.pokemon = poke //Make whatever the sender is into the pokemon
                }
            }
        }
    }
}

