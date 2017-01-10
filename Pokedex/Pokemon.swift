//
//  Pokemon.swift
//  Pokedex
//
//  Created by Blu on 1/4/17.
//  Copyright © 2017 Blu. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonUrl: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }

    var type: String {
        
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    //" /api/v1/pokemon/1/"
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId!)" //URL is generated for each pokemon. URL_BASE and URL_POKEMON is from the Constants file
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) { //function for making a HTTP call to the PokeAPI
        let url = URL(string: _pokemonUrl)! //Creates a string into a URL
        Alamofire.request(url).responseJSON { (DataResponse) -> Void in //Passes URL onto alamofire to do the call
            print(DataResponse.result.value.debugDescription)
            
            if let dict = DataResponse.result.value as? Dictionary<String, AnyObject> { //turn result into a dictionary
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight //makes the definition of "weight" into the string
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = String(defense)
                }
                
                if let type = dict["type"] as? String {
                    self._type = type
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = String(attack)
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {//if types is not nil {//Value of "types" in pokeapi is an Array of two string types
               
                    if let name = types[0]["name"] { //grabs first element of name
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                              self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = URL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(nsurl).responseJSON { (DataResponse) -> Void in
                            
                            if let descDict = DataResponse.result.value as? Dictionary<String, AnyObject> { //
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            completed() //fulfills the closure. IMPORTANT! returns
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 1 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        if to.range(of: "mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let num = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                            }
                        }
                    }
                }
        }
    }
}

}
