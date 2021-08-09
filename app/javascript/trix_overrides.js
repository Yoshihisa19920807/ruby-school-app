// window.addEventListener("trix-file-accept", function(e) {
//     // console.log("trix-file-accept_")
//     e.preventDefault()
//     alert("Any file attachment is not supported")
// })

// window.addEventListener("trix-file-accept", function(event) {
//   const acceptedTypes = ['image/jpeg', 'image/png']
//   if (!acceptedTypes.includes(event.file.type)) {
//     event.preventDefault()
//     alert("Only support attachment of jpeg or png files")
//   }
// })

window.addEventListener("trix-file-accept", function(event) {
//   const maxFileSize = 1024 * 1024 // 1MB
const maxFileSize = 4024 * 4024 
  if (event.file.size > maxFileSize) {
    event.preventDefault()
    alert("Only support attachment files upto size 1MB!")
  }
})
