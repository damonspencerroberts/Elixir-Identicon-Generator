searchNodes=[{"doc":"This is a method that creates a unique Identicon for an inputed string and outputs a png file with the unique Identicon image.","ref":"Ident.html","title":"Ident","type":"module"},{"doc":"This function creates a list of tuples containing the hex number and its index. Function def create_grid ( % Ident.Image { hex : hex } = image ) do grid = hex |&gt; List . delete_at ( length ( hex ) - 1 ) |&gt; Enum . chunk_every ( 3 ) |&gt; Enum . map ( &amp; create_row / 1 ) |&gt; List . flatten ( ) |&gt; Enum . with_index ( ) % Ident.Image { image | grid : grid } end","ref":"Ident.html#create_grid/1","title":"Ident.create_grid/1","type":"function"},{"doc":"This functions creates a chunk or sub-list that is symetrical. Function def create_row ( chunk ) do [ a , b , _c ] = chunk chunk ++ [ b , a ] end","ref":"Ident.html#create_row/1","title":"Ident.create_row/1","type":"function"},{"doc":"This functions creates the points for the squares. It creates a list of tuples of tuples that contains the coordinates of the top left square and the coordinate of the bottom right square. Calculated using the index. Function def create_squares ( % Ident.Image { grid : grid } = image ) do grid_squares = Enum . map ( grid , fn { _code , index } -&gt; horizontal = rem ( index , 5 ) * 50 vertical = div ( index , 5 ) * 50 top_left = { horizontal , vertical } bottom_right = { horizontal + 50 , vertical + 50 } { top_left , bottom_right } end ) % Ident.Image { image | grid_squares : grid_squares } end","ref":"Ident.html#create_squares/1","title":"Ident.create_squares/1","type":"function"},{"doc":"This function draws the image with the egd drawer and then renders the image to container built. Function def draw_the_image ( % Ident.Image { color : color , grid_squares : grid_squares } ) do container = :egd . create ( 250 , 250 ) color_square = :egd . color ( color ) Enum . each ( grid_squares , fn { top_left , bottom_right } -&gt; :egd . filledRectangle ( container , top_left , bottom_right , color_square ) end ) :egd . render ( container ) end","ref":"Ident.html#draw_the_image/1","title":"Ident.draw_the_image/1","type":"function"},{"doc":"This function filters the grid to only output even hex numbers. Function def filter_odds ( % Ident.Image { grid : grid } = image ) do filtered_grid = Enum . filter ( grid , fn { code , _index } -&gt; rem ( code , 2 ) == 0 end ) % Ident.Image { image | grid : filtered_grid } end","ref":"Ident.html#filter_odds/1","title":"Ident.filter_odds/1","type":"function"},{"doc":"This function turns a string into a hash with the md5 algorithm. It then converts that to a list of integers. Function def hash_string ( string ) do hex = :crypto . hash ( :md5 , string ) |&gt; :binary . bin_to_list ( ) % Ident.Image { hex : hex } end","ref":"Ident.html#hash_string/1","title":"Ident.hash_string/1","type":"function"},{"doc":"This is the main function that takes a string and filename as arguments. Then outputs the identicon to a png file. Function def main ( string , filename ) do string |&gt; hash_string |&gt; pick_color |&gt; create_grid |&gt; filter_odds |&gt; create_squares |&gt; draw_the_image |&gt; save_image ( filename ) end","ref":"Ident.html#main/2","title":"Ident.main/2","type":"function"},{"doc":"This function picks the color from the first three integers in the list. Function def pick_color ( % Ident.Image { hex : [ r , g , b | _tail ] } = image ) do % Ident.Image { image | color : { r , g , b } } end","ref":"Ident.html#pick_color/1","title":"Ident.pick_color/1","type":"function"},{"doc":"This function saves the final image to the the root of the directory with the filename inputed. ##Function def save_image ( image , filename ) do File . write ( &quot; \#{ filename } .png&quot; , image ) end","ref":"Ident.html#save_image/2","title":"Ident.save_image/2","type":"function"},{"doc":"This module is a struct module.","ref":"Ident.Image.html","title":"Ident.Image","type":"module"},{"doc":"This is the struct definition with keys of hex, color, grid and grid_squares. Struct defstruct hex : nil , color : nil , grid : nil , grid_squares : nil","ref":"Ident.Image.html#__struct__/0","title":"Ident.Image.__struct__/0","type":"function"}]