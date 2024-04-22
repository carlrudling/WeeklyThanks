import SwiftUI
import TOCropViewController

struct AddImageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coordinator: NavigationCoordinator
       @EnvironmentObject var userViewModel: UserViewModel
       @State private var showingImagePicker = false
       @State private var showingCropView = false
       
       var body: some View {
           VStack {
               Button(action: {
                   self.showingImagePicker = true
               }) {
                   if let image = userViewModel.profileImage {
                       ZStack{
                           Image(systemName: "circle")
                               .resizable()
                               .scaledToFit()
                               .frame(width: 140, height: 140)
                               .foregroundColor(.white)
                           Image(uiImage: image)
                               .resizable()
                               .scaledToFit()
                               .frame(width: 130, height: 130)
                               .clipShape(Circle()) // Display the selected image as a circle
                       }
                       .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)


                   } else {
                       ZStack{
                           
                           Image(systemName: "photo.circle.fill")
                               .resizable()
                               .scaledToFit()
                               .frame(width: 130, height: 130)
                               .foregroundColor(.white.opacity(0.6))
                               .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                           Text("Choose image")
                               .font(.custom("Chillax", size: 16))
                               .foregroundColor(.gray)
                       }
                   }
               }
               .padding()
               .sheet(isPresented: $showingImagePicker, onDismiss: {
                   // Check if an image was picked before showing the crop view
                   if userViewModel.profileImage != nil {
                       self.showingCropView = true
                   }
               }) {
                   ImagePicker(selectedImage: $userViewModel.profileImage)
               }
               .sheet(isPresented: $showingCropView) {
                   CropImageView(image: $userViewModel.profileImage)
                       .edgesIgnoringSafeArea(.all) // Apply this modifier

               }
            
            Text("Start by uploading an image that represent your inner child / younger self.")
                .font(.custom("Chillax", size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        
            
            Spacer()
            
            Button(action: {
                userViewModel.saveProfileImage()
                coordinator.push(.writeThankMe) // Navigate to writing a thank-you card
                // Navigate or perform next action
            }) {
                HStack {
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.clear)
                    Spacer()
                    Text("Next")
                        .font(.custom("Chillax", size: 18))
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 250, height: 40)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.backgroundDarkBlue.opacity((userViewModel.profileImage != nil) ? 1.0 : 0.5)))
            }
            .disabled(userViewModel.profileImage == nil)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundDarkBlue, .backgroundLightBlue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .padding(12)
                }
            }
        }
    }
}




#Preview {
    AddImageView()
}



struct CropImageView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> TOCropViewController {
        guard let unwrappedImage = image else {
            return TOCropViewController(croppingStyle: .circular, image: UIImage())
        }
        let cropViewController = TOCropViewController(croppingStyle: .circular, image: unwrappedImage)
        cropViewController.delegate = context.coordinator
        // Extend the crop view controller's edges to ignore the safe area
        cropViewController.view.clipsToBounds = true
        cropViewController.view.contentMode = .scaleAspectFill
        cropViewController.modalPresentationStyle = .fullScreen // Make sure it covers the full screen
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: TOCropViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, TOCropViewControllerDelegate {
        var parent: CropImageView
        
        init(_ parent: CropImageView) {
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
            parent.image = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // This function is intentionally left empty
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
