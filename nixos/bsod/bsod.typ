#import "@preview/cades:0.3.0": qr-code

#let background-color = rgb(0x00, 0x78, 0xd7)
#let url = "https://noratrieb.dev"
#let percent = sys.inputs.at("percent", default: "20");
#let stopcode = sys.inputs.at("stopcode", default: "KASAN_ENLIGHTENMENT_VIOLATION")

#set page(
  flipped: true,
  margin: (
    top: 184pt,
    right: 0pt,
    left: 190pt,
    bottom: 0pt,
  ),
  width: 1080pt,
  height: 1920pt,
  fill: background-color,
)

#set text(font: "Segoe UI")

#set text(rgb(255, 255, 255))

// :(
#text(size: 210pt, [:(])

#place(dx: 17pt, dy: 77pt, text(size: 42pt, [Your PC ran into a problem and needs to restart. We\'re]))
#place(dx: 21pt, dy: 136pt, text(size: 42pt, [just collecting some error info, and then we\'ll restart for]))
#place(dx: 19pt, dy: 195pt, text(size: 42pt, [you.]))

#place(dx: 18pt, dy: 284pt, text(size: 42pt, [#percent% complete]))

#place(dx: 152pt, dy: 371pt, text(
  size: 20pt,
  [For more information about this issue and possible fixes, visit https://www.windows.com/stopcode],
))

#place(dx: 17pt, dy: 371pt, [
  #rect(width: 115pt, height: 115pt, inset: 9pt, fill: white, qr-code(url, color: background-color))
])


#place(dx: 151pt, dy: 438pt, text(size: 16pt, [If you call a support person, give them this info:]))

#place(dx: 151pt, dy: 472pt, text(size: 16pt, [Stop code: #stopcode]))
