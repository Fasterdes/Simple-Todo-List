//NSManagedObject = dia dapat mengikat objeck model kita ke bagian antarmuka / interface / UI
//ManagedObjectContext = menyimpan konteks objek yang terkelola

//fetch request = tugas nya menampilkan hasil proses data dari managedObjectContext untuk ditampilkan ke halaman interface aplikasi
//ascending = urutan dari yang terkecil ke terbesar
//descending = urutan dari yang tebesar ke terkecil
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // Untuk memanggil data atau mengambil data dari SceneDelegate ( Icon )
    @EnvironmentObject var iconSettings : IconNames
    
    @FetchRequest(entity: Todo.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name,ascending: true)]) var todos: FetchedResults<Todo>
    @State private var showingAddTodo: Bool = false // State untuk membuka AddTodoView ( Buat nambah Add To Do )
    
    
    @State private var showingSettingsView : Bool = false // State untuk membuka SettingsView
    var body: some View {
        NavigationView{
            ZStack{
                List{
                    ForEach(self.todos,id: \.self){todo in
                        HStack{
                            Text(todo.name ?? "Unknown")
                            
                            Spacer()
                            
                            Text(todo.priority ?? "Unknown")
                        }
                    }
                    .onDelete(perform: deleteTodo)
                }.navigationBarTitle("Todo",displayMode: .inline)
                .navigationBarItems(leading: EditButton(), trailing:
                                        Button(action : {
                                            self.showingSettingsView.toggle() //true
                                        }){
                                            Image(systemName: "paintbrush")
                                        }
                    .sheet(isPresented: $showingSettingsView){
                        SettingsView().environmentObject(self.iconSettings)
                    }
                )
                
                if todos.count ==  0{
                    EmptyListView()
                }
            }
            
            .sheet(isPresented: $showingAddTodo){
                AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
            }
            
            .overlay(
                ZStack{
                    Button(action : {
                        self.showingAddTodo.toggle()
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
                
                .padding(.bottom , 15)
                .padding(.trailing , 15)
                ,alignment: .bottomTrailing
            )
            
            
        }
    }
    
    private func deleteTodo(at offsets: IndexSet){ //komponen array = objek urutan array nama lain adalah index
        for index in offsets{
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do{
                try managedObjectContext.save()
            }catch{
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
    }
}


/*
 
 CATATAN
 
 1. Self adalah : mengambil data dari @State 
 
 2. Perbedaan self dan Self ( perbedaan huruf kapital )
 
    adalah : kalo self , s nya kecil masih mengambil  di dalam struct yang sama sedangkan self S nya gede mengambil data berbeda struct
 
 
 
 
 */
