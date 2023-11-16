//
//  LexicalMarkdownUtils.swift
//
//
//  Created by mani on 16/11/2023.
//

import Foundation
import Lexical
import Markdown

extension Array where Element == Node {
  func exportAsInlineMarkdown(indentation: Int) -> [Markdown.InlineMarkup] {
    compactMap {
      try? ($0 as? NodeMarkdownInlineSupport)?.exportMarkdown(indentation: indentation)
    }
  }

  func exportAsBlockMarkdown() -> [Markdown.BlockMarkup] {
    compactMap {
      try? ($0 as? NodeMarkdownBlockSupport)?.exportMarkdown()
    }
  }
}
