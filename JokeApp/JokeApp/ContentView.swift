//
//  ContentView.swift
//  JokeApp
//
//  Created by Lesley Lopez on 8/5/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var jokeText = "Tap the button below for a joke!"
    
    var body: some View {
        
        ZStack{
            Color.red
                .ignoresSafeArea()
            VStack{
                Text("My Joke App")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.top)
                
                Spacer()
                
                Text(jokeText)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                    
                
                
                Button(action: {
                    Task{
                        await fetchJoke()
                    }
                },
                       
                       label: {
                    Text("HAHA")
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 50, height: 50)))
                })
                .padding(.top)
                
                Spacer()
            }
            
        }
        }
       
    
    func fetchJoke() async{
        do{
          
            var newJoke = try await callTheJoke()
            jokeText = newJoke
        }catch {
            jokeText = "There was a problem fetching the joke bro"
        }
    }
    
    func callTheJoke() async throws->String {
        //make the api call here
      
        //URL end point
        
        if let url = URL(string:"https://v2.jokeapi.dev/joke/Any?type=single") {
            //Do URL request
            var request = URLRequest(url: url)
           
            do{
                let (data, response) = try await URLSession.shared.data(for:request)
                
                
                let decoder = JSONDecoder()
                do{
                    let results = try decoder.decode(JokeResponse.self, from: data)
                    
                    
                    
                    return results.joke ?? "Sorry no joke today"
                    
                    
                }
                catch {
                    print(error)
                }
                
            } catch {
                print(error)
            }
        }
        
        return "No joke returned!"
        
    }
}

#Preview {
    ContentView()
}
