//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Blu on 1/5/17.
//  Copyright © 2017 Blu. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    @IBOutlet weak var pokeName: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var lvlToEvoLbl: UILabel!

    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    pokeName.text = pokemon.name
    let img = UIImage(named: "\(pokemon.pokedexId)")
    mainImg.image = img
    currentEvoImg.image = img
        
        
        pokemon.downloadPokemonDetails {
            self.updateUI() //add self. because we're inside of a closure
        }
    }

    
    func updateUI() {
            typeLbl.text = pokemon.type
            defenseLbl.text = pokemon.defense
            heightLbl.text = pokemon.height
            weightLbl.text = pokemon.weight
            baseAttackLbl.text = pokemon.attack
            descriptionLbl.text = pokemon.description
            pokedexLbl.text = "\(pokemon.pokedexId)"
        
        if pokemon.nextEvolutionId == "" {
            lvlToEvoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
           nextEvoImg.isHidden = false
           nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
           var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
                lvlToEvoLbl.text = str
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backbtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
