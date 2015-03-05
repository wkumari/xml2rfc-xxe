# Table Rendering #

The xml2rfc 

&lt;texttable&gt;

 attribute is mostly unsupported at this time. It will render a table that should look like this:


| Heading One | Heading Two |
|:------------|:------------|
| Hello       | World       |
| I am a      | table       |

as follows:

```
  c1: Heading One
                    c2: Heading Two
r1c1: Hello
                  r1c2: World
r2c1: I am a
                  r2c2: table
```

If there are not enough 

&lt;c&gt;

 elements to make up the content of the table, a warning will follow the table.

While this form allows editing and generation of tables, it is not intuitive and it may take some creative thinking to see how the layout will end up. Far from WYSIWYG. This is definitely an area for improvement.

xxe has native table support, but requires row elements to wrap sets of cells; there is no straightforward way at this time to support the xml2rfc schema's type of table that just has a series of cells with no row elements.