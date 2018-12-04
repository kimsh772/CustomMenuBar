# CustomMenuBar

swift SnapKit using menubar

require SnapKit

var dataMenu = ["1","2","3","4","5"]

let menu = CustomMenuBar()
menu.setData(dataMenu)

// set delegate
menu.delegate = self

extension Test: CustomMenuBarDelegate {
    func customMenuBar(scrollTo index: Int) {
      print("now select index \(index) ")
    }
}
