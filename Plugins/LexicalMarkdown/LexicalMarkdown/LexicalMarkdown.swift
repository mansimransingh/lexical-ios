//
//  LexicalMarkdown.swift
//
//
//  Created by mani on 15/11/2023.
//

import Foundation
import Markdown
import Lexical

open class LexicalMarkdown: Plugin {
  public init() {}

  weak var editor: Editor?

  public func setUp(editor: Editor) {
    self.editor = editor
  }

  public func tearDown() {
  }

  public class func generateMarkdown(from editor: Editor, 
                                     selection: BaseSelection?) throws -> String {
    guard let root = editor.getEditorState().getRootNode() else {
      return ""
    }

    return Markdown.Document(root.getChildren().exportAsBlockMarkdown()).format()
  }
}
