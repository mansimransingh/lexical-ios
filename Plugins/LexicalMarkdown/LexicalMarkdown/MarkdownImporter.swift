//
//  MarkdownImporter.swift
//
//
//  Created by mani on 16/11/2023.
//

import Foundation
import Lexical
import Markdown

struct MarkdownImporter: MarkupVisitor {
  typealias Result = Lexical.Node

  private var currentNode: Lexical.Node?

  init(root: Lexical.Node) {
    self.currentNode = root
  }

  mutating func defaultVisit(_ markup: Markup) -> Lexical.Node {
    var paragraph = createParagraphNode()
    try? paragraph.append(markup.children.map({
      return visit($0)
    }))


//    let text = createTextNode(text: (markup as? Text).map { $0.string })
//    return text
    return paragraph
    //    return XML(tag: String(describing: type(of: markup)),
    //               children: markup.children.map { defaultVisit($0) },
    //               text: (markup as? Text).map { $0.string })
  }

  mutating func visit(_ markup: Markup) -> Lexical.Node {
    return markup.accept(&self)
  }

  mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> Lexical.Node {
    return defaultVisit(blockQuote)
  }

  mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> Lexical.Node {
    return defaultVisit(codeBlock)
  }

  mutating func visitCustomBlock(_ customBlock: CustomBlock) -> Lexical.Node {
    return defaultVisit(customBlock)
  }

  mutating func visitDocument(_ document: Document) -> Lexical.Node {
    return defaultVisit(document)
  }

  mutating func visitHeading(_ heading: Heading) -> HeadingNode {
    var node: HeadingNode
    switch heading.level {
    case 1:
      node = createHeadingNode(headingTag: .h1)
    case 2:
      node = createHeadingNode(headingTag: .h2)
    case 3:
      node = createHeadingNode(headingTag: .h3)
    case 4:
      node = createHeadingNode(headingTag: .h4)
    case 5:
      node = createHeadingNode(headingTag: .h5)
    default:
      node = createHeadingNode(headingTag: .h1)
    }
    try? node.append([createTextNode(text: heading.plainText)])
    return node
  }

  mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> Lexical.Node {
    return defaultVisit(thematicBreak)
  }

  mutating func visitHTMLBlock(_ html: HTMLBlock) -> Lexical.Node {
    return defaultVisit(html)
  }

  mutating func visitListItem(_ listItem: ListItem) -> Lexical.Node {
    return defaultVisit(listItem)
  }

  mutating func visitOrderedList(_ orderedList: OrderedList) -> Lexical.Node {
    return defaultVisit(orderedList)
  }

  mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> Lexical.Node {
    return defaultVisit(unorderedList)
  }

  mutating func visitParagraph(_ paragraph: Paragraph) -> Lexical.Node {
    return defaultVisit(paragraph)
  }

  mutating func visitBlockDirective(_ blockDirective: BlockDirective) -> Lexical.Node {
    return defaultVisit(blockDirective)
  }

  mutating func visitInlineCode(_ inlineCode: InlineCode) -> Lexical.Node {
    return defaultVisit(inlineCode)
  }

  mutating func visitCustomInline(_ customInline: CustomInline) -> Lexical.Node {
    return defaultVisit(customInline)
  }

  mutating func visitEmphasis(_ emphasis: Emphasis) -> Lexical.Node {
    return defaultVisit(emphasis)
  }

  mutating func visitImage(_ image: Image) -> Lexical.Node {
    return defaultVisit(image)
  }

  mutating func visitInlineHTML(_ inlineHTML: InlineHTML) -> Lexical.Node {
    return defaultVisit(inlineHTML)
  }

  mutating func visitLineBreak(_ lineBreak: LineBreak) -> Lexical.Node {
    return defaultVisit(lineBreak)
  }

  mutating func visitLink(_ link: Link) -> Lexical.Node {
    return defaultVisit(link)
  }

  mutating func visitSoftBreak(_ softBreak: SoftBreak) -> Lexical.Node {
    return defaultVisit(softBreak)
  }

  mutating func visitStrong(_ strong: Strong) -> Lexical.Node {
    return defaultVisit(strong)
  }

  mutating func visitText(_ text: Text) -> Lexical.Node {
    return defaultVisit(text)
  }

  mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> Lexical.Node {
    return defaultVisit(strikethrough)
  }

  mutating func visitTable(_ table: Table) -> Lexical.Node {
    return defaultVisit(table)
  }

  mutating func visitTableHead(_ tableHead: Table.Head) -> Lexical.Node {
    return defaultVisit(tableHead)
  }

  mutating func visitTableBody(_ tableBody: Table.Body) -> Lexical.Node {
    return defaultVisit(tableBody)
  }

  mutating func visitTableRow(_ tableRow: Table.Row) -> Lexical.Node {
    return defaultVisit(tableRow)
  }

  mutating func visitTableCell(_ tableCell: Table.Cell) -> Lexical.Node {
    return defaultVisit(tableCell)
  }

  mutating func visitSymbolLink(_ symbolLink: SymbolLink) -> Lexical.Node {
    return defaultVisit(symbolLink)
  }

  mutating func visitInlineAttributes(_ attributes: InlineAttributes) -> Lexical.Node {
    return defaultVisit(attributes)
  }

  mutating func visitDoxygenParameter(_ doxygenParam: DoxygenParameter) -> Lexical.Node {
    return defaultVisit(doxygenParam)
  }

  mutating func visitDoxygenReturns(_ doxygenReturns: DoxygenReturns) -> Lexical.Node {
    return defaultVisit(doxygenReturns)
  }
}
