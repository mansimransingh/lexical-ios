/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

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

  public func initialiseWithMarkdown(string: String) throws {
    try editor?.update {
      guard let root = self.editor?.getEditorState().getRootNode() else {
        throw LexicalError.internal("Failed to parse")
      }

      let document = Document(parsing: string)

      var importer = MarkdownImporter()
      try root.append([importer.visit(document)])
    }
  }
}
