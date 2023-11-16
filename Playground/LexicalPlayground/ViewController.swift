/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import EditorHistoryPlugin
import Lexical
import LexicalInlineImagePlugin
import LexicalMarkdown
import LexicalLinkPlugin
import LexicalListPlugin
import UIKit

class ViewController: UIViewController, UIToolbarDelegate {

  var lexicalView: LexicalView?
  weak var toolbar: UIToolbar?
  weak var hierarchyView: UIView?
  weak var markdownView: UIView?
  private let editorStatePersistenceKey = "editorState"
  private let stack = UIStackView()

  private let lexicalPlugin = LexicalMarkdown()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    let editorHistoryPlugin = EditorHistoryPlugin()
    let toolbarPlugin = ToolbarPlugin(viewControllerForPresentation: self, 
                                      historyPlugin: editorHistoryPlugin)
    let toolbar = toolbarPlugin.toolbar
    toolbar.delegate = self

    let hierarchyPlugin = NodeHierarchyViewPlugin(isHierarchy: true)

    let listPlugin = ListPlugin()
    let imagePlugin = InlineImagePlugin()

    let linkPlugin = LinkPlugin()

    let theme = Theme()
    theme.indentSize = 40.0
    theme.link = [
      .foregroundColor: UIColor.systemBlue,
    ]

    let editorConfig = EditorConfig(theme: theme, plugins: [toolbarPlugin, listPlugin, hierarchyPlugin, lexicalPlugin, imagePlugin, linkPlugin, editorHistoryPlugin])
    let lexicalView = LexicalView(editorConfig: editorConfig, featureFlags: FeatureFlags())

    linkPlugin.lexicalView = lexicalView

    self.lexicalView = lexicalView
    self.toolbar = toolbar
    self.hierarchyView = hierarchyPlugin.hierarchyView
//    self.markdownView = markdownPlugin.hierarchyView

    self.restoreEditorState()

    view.addSubview(toolbar)
    view.addSubview(stack)
    
    stack.axis = .vertical
    stack.distribution = .fillEqually
    stack.addArrangedSubview(lexicalView)
    stack.addArrangedSubview(hierarchyPlugin.hierarchyView)
//    stack.addArrangedSubview(markdownPlugin.hierarchyView)

    navigationItem.title = "Lexical"
    setUpExportMenu()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if let toolbar {
      let safeAreaInsets = self.view.safeAreaInsets

      toolbar.frame = CGRect(x: 0,
                             y: safeAreaInsets.top,
                             width: view.bounds.width,
                             height: 44)
      
      stack.frame = CGRect(x: 0,
                           y: toolbar.frame.maxY,
                           width: view.bounds.width,
                           height: view.bounds.height - toolbar.frame.maxY - safeAreaInsets.bottom)
    }
  }

  func persistEditorState() {
    guard let editor = lexicalView?.editor else {
      return
    }

    let currentEditorState = editor.getEditorState()

    // turn the editor state into stringified JSON
    guard let jsonString = try? currentEditorState.toJSON() else {
      return
    }

    UserDefaults.standard.set(jsonString, forKey: editorStatePersistenceKey)
  }

  func restoreEditorState() {
    guard let editor = lexicalView?.editor else {
      return
    }

    guard let jsonString = UserDefaults.standard.value(forKey: editorStatePersistenceKey) as? String else {
      return
    }

    // turn the JSON back into a new editor state
    guard let newEditorState = try? EditorState.fromJSON(json: jsonString, editor: editor) else {
      return
    }

    // install the new editor state into editor
    try? editor.setEditorState(newEditorState)
  }

  func setUpExportMenu() {
    let menuItems = OutputFormat.allCases.map { outputFormat in
      UIAction(title: "Export \(outputFormat.title)", handler: { [weak self] action in
        self?.showExportScreen(outputFormat)
      })
    }
    let loadTest = UIAction(title: "Load test string") { [weak self] action in
      self?.loadTestString()
    }
    let menu = UIMenu(title: "Export as…", children: menuItems + [loadTest])
    let barButtonItem = UIBarButtonItem(title: "Export", style: .plain, target: nil, action: nil)
    barButtonItem.menu = menu
    navigationItem.rightBarButtonItem = barButtonItem
  }

  private func loadTestString() {
    try? lexicalPlugin.initialiseWithMarkdown(string: String.testMarkdown)
  }

  func showExportScreen(_ type: OutputFormat) {
    guard let editor = lexicalView?.editor else { return }
    let vc = ExportOutputViewController(editor: editor, format: type)
    navigationController?.pushViewController(vc, animated: true)
  }

  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .top
  }
}

private extension String {
  static var testMarkdown: String {
    """
---
__Advertisement :)__

- __[pica](https://nodeca.github.io/pica/demo/)__ - high quality and fast image
  resize in browser.
- __[babelfish](https://github.com/nodeca/babelfish/)__ - developer friendly
  i18n with plurals support and easy syntax.

You will like those projects!

---

# h1 Heading 8-)
## h2 Heading
### h3 Heading
#### h4 Heading
##### h5 Heading
###### h6 Heading


## Horizontal Rules

___

---

***


## Typographic replacements

Enable typographer option to see result.

(c) (C) (r) (R) (tm) (TM) (p) (P) +-

test.. test... test..... test?..... test!....

!!!!!! ???? ,,  -- ---

"Smartypants, double quotes" and 'single quotes'


## Emphasis

**This is bold text**

__This is bold text__

*This is italic text*

_This is italic text_

~~Strikethrough~~


## Blockquotes


> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.


## Lists

Unordered

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar


## Code

Inline `code`

Indented code

    // Some comments
    line 1 of code
    line 2 of code
    line 3 of code


Block code "fences"

```
Sample text here...
```

Syntax highlighting

``` js
var foo = function (bar) {
  return bar++;
};

console.log(foo(5));
```

## Tables

| Option | Description |
| ------ | ----------- |
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |

Right aligned columns

| Option | Description |
| ------:| -----------:|
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |


## Links

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")

Autoconverted link https://github.com/nodeca/pica (enable linkify to see)
"""
  }
}
