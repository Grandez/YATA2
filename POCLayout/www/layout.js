class JGGLayout2 {
    id;
   #loaded = false;
   #items = Array(5);
   #layout;
   constructor(id)  {
      this.id   = id;
      this.#init();
      this.#loaded = false;
   }
   init() {
       console.log("init");
   }
   changed (cbo) { // recibe namespace_layout_idx
      if (!this.#loaded) this.#init();
       console.log("changed " + cbo);
       const toks = cbo.split("_"); // ns_layout_id
       let id   = toks[0];
       let item = toks[2];

       Shiny.setInputValue(this.id, {type: "changed", block: i, value: this.#items[i]}, {priority: "event"});

       this.#change_layout();
   }
   #init() {
      let checkCombo = document.getElementById(this.id + "_layout_" + 1);
      this.#loaded = (checkCombo === null) ? false : true;
      if (!this.#loaded) return;
      this.#items[0] = "";
      let blocks = [];
      for (let i = 1; i < 5; i++) {
           this.#items[i] = document.getElementById(this.id + "_layout_" + i).value;
           blocks.push(this.#items[i]);
      }
     Shiny.setInputValue(this.id, {type: "init", value: blocks}, {priority: "event"});
      this.#change_layout();
   }
   #change_layout() {
       let newLayout = this.#get_layout();
       this.#show_blocks();
       let divs = this.#select_layout()
       this.#set_items(divs);

   }
   #get_layout() { // Identifca el layout actual
     let lay = 0;
     let checks = [0, 0, 0];
     for (let idx = 1; idx < 5; idx++ ) {
         switch (this.#items[idx]) {
             case "rows": checks[0]++; break; // Rows
             case "cols": checks[2]++; break; // cols
             default:     checks[1]++; break; // values
         }
     }
     if (checks[1] == 1) return 10;
     if (checks[1] == 4) return 40;
     if (checks[1] == 3) {
         if (checks[0] > 0) { // 1 rows
             lay = 310;
             if (items[1] != "rows" && items[2] != "rows") lay++;
         } else { // 1 cols
             lay = 320;
             if (items[1] != "cols" && items[3] != "cols") lay++;
         }
         return lay;
     }
     // Hay dos items
     if (this.#is_tag(1) && this.#is_tag(2)) return 22;
     if (this.#is_tag(3) && this.#is_tag(4)) return 22;
     if (this.#items[1] == "rows" || this.#items[1] == "rows") return 21;
     return 22;
  }
   #select_layout() {
      let divs = [];
      const type = this.#get_layout();
      if (type == 10) divs = ["full"];
      if (type == 40) divs = ["detail_1_1", "detail_1_2", "detail_2_1", "detail_2_2"];

      if (type == 310) divs = ["rows_1_0", "rows_2_1", "rows_2_2"];
      if (type == 311) divs = ["rows_1_1", "rows_1_2", "rows_2_0"];

      // Hay solo un cols
      if (type == 320) {
          if (items[1] == "cols") divs = ["cols_2_1", "cols_1_0", "cols_2_2"];
          else                    divs = ["cols_1_1", "cols_1_2", "cols_2_0"];
      }
      if (type == 321) {
          if (items[2] == "cols") divs = ["cols_2_1", "cols_2_2", "cols_2_0"];
          else                    divs = ["cols_1_1", "cols_2_0", "cols_1_2"];
      }

      // Hay dos rows o cols uno en cada fila/columna
      if (type == 21)  divs = ["rows_1_0", "rows_2_0"];
      if (type == 22)  {
          if (items[1] == "cols" || items[3] == "cols")
              divs = ["cols_2_0", "cols_1_0"];
          else {
              divs = ["cols_1_0", "cols_2_0"];
          }
      }
      return divs;
  }
   #set_items (divs) {
      let items = [];
      for (let i = 1; i < 5; i++) {
          if (this.#items[i] != "rows" && this.#items[i] != "cols") items.push(i);
      }
      for (let i = 0; i < divs.length; i++) {
          let tgt = document.getElementById(this.id + "_layout_" + divs[i]);
          tgt.appendChild(document.getElementById(this.id + "_layout_data_" + items[i]));
      }
  }
   #show_blocks () {
    let block_layout
    const layout = this.#get_layout()

    const layouts = document.querySelectorAll('.jgg_layout_block_container');
    layouts.forEach(lay => { lay.style.display = 'none'; });
    switch (layout) {
        case 10:  block_layout = "full";   break;
        case 21:  block_layout = "rows";   break;
        case 22:  block_layout = "cols";   break;
        case 40:  block_layout = "detail"; break;
        case 310:
        case 311: block_layout = "rows";   break;
        case 320:
        case 321: block_layout = "cols";   break;

    }
    document.getElementById(this.id + "_layout_" + block_layout).style.display = "block";

    const base = this.id + "_layout_";
    switch (layout) {
        case 10:  break;
        case 21:
        case 22:
             document.getElementById(base + block_layout + "_0").style.display = "block";
             document.getElementById(base + block_layout + "_1").style.display = "none";
             document.getElementById(base + block_layout + "_2").style.display = "none";
             break;
        case 40:  break;
        case 310:
        case 320:
             document.getElementById(base + block_layout + "_1_0").style.display = "block";
             document.getElementById(base + block_layout + "_1_1").style.display = "none";
             document.getElementById(base + block_layout + "_1_2").style.display = "none";
             break;
        case 311:
        case 321:
             document.getElementById(base + block_layout + "_2_0").style.display = "block";
             document.getElementById(base + block_layout + "_2_1").style.display = "none";
             document.getElementById(base + block_layout + "_2_2").style.display = "none";
             break;
    }
  }
   #is_tag (idx) {
      if (this.items == "rows") return true;
      if (this.items == "cols") return true;
      return false;
  }
}
/*
function jgglayout_init (id) {
    jggshiny.init(id);
}
$(document).on('shiny:sessioninitialized', function(event) {
  console.log("inicializado");
});
$(document).on('shiny:connected', function(event) {
  console.log('Connected to the server');
  globalThis.jgglayout = new JGGLayout('prueba');
  Shiny.addCustomMessageHandler("jgg_init_layout", jgglayout_init );
});
jQuery(document).ready(function() {
    //globalThis.jgglayout = new JGGLayout('prueba');
});
*/
