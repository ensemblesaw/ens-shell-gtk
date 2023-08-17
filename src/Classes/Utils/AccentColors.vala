/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles {
    public class AccentColors {
        private const string COMPLIMENTARY_ACCENT_COLORS_TEMPLATE =
        "
        @define-color accent_color_complimentary %s;
        @define-color accent_color_complimentary_alternate %s;
        ";

        private static string complimentary_accent_colors_strawberry
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@BANANA_500", "@ORANGE_500");
        private static string complimentary_accent_colors_orange
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@BLUEBERRY_500", "@MINT_500");
        private static string complimentary_accent_colors_banana
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@MINT_500", "@ORANGE_500");
        private static string complimentary_accent_colors_lime
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@BANANA_500", "@BUBBLEGUM_500");
        private static string complimentary_accent_colors_mint
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@BANANA_500", "@SILVER_500");
        private static string complimentary_accent_colors_blueberry
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@GRAPE_500", "@MINT_500");
        private static string complimentary_accent_colors_bubblegum
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@MINT_500", "@GRAPE_500");
        private static string complimentary_accent_colors_cocoa
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@MINT_500", "@BANANA_500");
        private static string complimentary_accent_colors_grape
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@STRAWBERRY_300", "@BUBBLEGUM_500");
        private static string complimentary_accent_colors_silver
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@BLUEBERRY_300", "@STRAWBERRY_300");
        private static string complimentary_accent_colors_slate
        = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@MINT_500", "@BANANA_500");

        public static string get_complementary (string theme_color) {
            complimentary_accent_colors_strawberry
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@BANANA_500", "@ORANGE_500");
            complimentary_accent_colors_orange
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@BLUEBERRY_500", "@MINT_500");
            complimentary_accent_colors_banana
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@MINT_500", "@ORANGE_500");
            complimentary_accent_colors_lime
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@BANANA_500", "@BUBBLEGUM_500");
            complimentary_accent_colors_mint
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@BANANA_500", "@SILVER_500");
            complimentary_accent_colors_blueberry
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@GRAPE_500", "@MINT_500");
            complimentary_accent_colors_bubblegum
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@MINT_500", "@GRAPE_500");
            complimentary_accent_colors_cocoa
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@MINT_500", "@BANANA_500");
            complimentary_accent_colors_grape
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@STRAWBERRY_300", "@BUBBLEGUM_500");
            complimentary_accent_colors_silver
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@BLUEBERRY_300", "@STRAWBERRY_300");
            complimentary_accent_colors_slate
            = COMPLIMENTARY_ACCENT_COLORS_TEMPLATE.printf ("@MINT_500", "@BANANA_500");

            switch (theme_color) {
                case "strawberry":
                    return complimentary_accent_colors_strawberry;
                case "orange":
                    return complimentary_accent_colors_orange;
                case "banana":
                    return complimentary_accent_colors_banana;
                case "lime":
                    return complimentary_accent_colors_lime;
                case "mint":
                    return complimentary_accent_colors_mint;
                case "blueberry":
                    return complimentary_accent_colors_blueberry;
                case "grape":
                    return complimentary_accent_colors_grape;
                case "bubblegum":
                    return complimentary_accent_colors_bubblegum;
                case "cocoa":
                    return complimentary_accent_colors_cocoa;
                case "silver":
                    return complimentary_accent_colors_silver;
                case "slate":
                case "black":
                    return complimentary_accent_colors_slate;
            }

            return complimentary_accent_colors_blueberry;
        }
    }
}
