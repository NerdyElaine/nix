require("orgmode").setup({
    org_agenda_files = '~/orgfiles/**/*',
    org_default_notes_file = '~/orgfiles/refile.org',
    org_highlight_latex_and_related = 'entities',
    win_split_mode = 'vertical',
})
require("org-roam").setup({
    directory = '~/orgfiles/notes/',
    templates = {
        p = {
            description = "permanent notes",
            template = [[
#+date: %<%Y-%m-%d>
#+filetags: :permanent:

* Idea
%?

* Details

* Connections
            ]],
            target = "permanent/%<%Y%m%d%H%M%S>-%[slug].org",
        },
        l = {
            description = "literature notes",
            template = [[
#+date: %<%Y-%m-%d>
#+filetags: :literature:

* Summary
%?

* Key Points

* Source
            ]],
            target = "literature/%<%Y%m%d%H%M%S>-%[slug].org",

        },
        m = {
            description = "math mote",
            template = [[
#+date: %<%Y-%m-%d>
#+filetags: :math:


* Statement
%?

* Intuition

* Key Idea

* Connections

* Examples

* References
            ]],
            target = "math/%<%Y%m%d%H%M%S>-%[slug].org",
        },
        i = {
            description = "index/topic",
            template = [[
#+date: %<%Y-%m-%d>
#+filetags: :index:

* Related
- %?
            ]],
            target = "index/%[slug].org"
        },
        f = {
            description = "fleeting",
            template = [[
#+date: %<%Y-%m-%d>
#+filetags: :fleeting:

* Note
%?
        ]],
            target = "fleeting/%[slug].org"
        },
    },
    extensions = {
        dailies = {
            templates = {
                d = {
                    description = "default",
                    template = [[
#+filetags: :daily:

*TODO Tasks

* Thoughts

* Notes

* Ideas

* Links
            ]],
                    target = "%<%Y-%m-%d>.org",

                }
            }
        }
    }
})

require('org-bullets').setup()

require('orgmode-babel').setup({
    langs = {"c", "javascript", "lua", "c++", "svelte", "typescript" },
    load_paths = {}
})
