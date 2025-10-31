#!/usr/bin/env nix-shell
#! nix-shell -i python -p python3
import os
from itertools import batched
from functools import reduce

def fill_up(card_page):
    def c(i):
        if len(card_page) > i:
            return card_page[i].path
        return "./cat.png"
    print("\\begin{tabular}{ l | c | c }")
    print(" \\card{%s} & \\card{%s} & \\card{%s} \\\\" % (c(1), c(2), c(3)))
    print(" \\card{%s} & \\card{%s} & \\card{%s} \\\\" % (c(4), c(5), c(6)))
    print(" \\card{%s} & \\card{%s} & \\card{%s} \\\\" % (c(7), c(8), c(0)))
    print("\\end{tabular}")

# gods require a sacrifice in form of a kitty page
fill_up(())

with os.scandir("./images") as entries:
    for card_page in batched(entries, 9):
        fill_up(card_page)
