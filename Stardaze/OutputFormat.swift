//
//  OutputFormat.swift
//  Stardaze
//
//  Created by William Wilson on 6/23/17.
//  Copyright © 2017 LeTote. All rights reserved.
//

/**
 Used to specify the output format for the stringify and parameterize methods on Document.
 */
public enum OutputFormat {
    /**
     Whitespace is minimized, but the output is not percent encoded.
     */
    case compact

    /**
     Whitespace is minimized and the output is percent encoded.
     */
    case encoded

    /**
     Include returns and tabs in the output.
     */
    case prettyPrinted
}
