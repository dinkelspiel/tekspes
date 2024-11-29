import glailwind_merge.{tw_merge}
import gleam/dict
import gleam/dynamic
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleamstar
import lustre
import lustre/attribute
import lustre/effect
import lustre/element
import lustre/element/html
import lustre/event

@external(javascript, "./collisions.mjs", "positions")
fn positions() -> List(#(Int, Int, Bool))

fn for(amount: Int, callback: fn(Int) -> a) {
  do_for(callback, amount, [])
}

fn do_for(callback: fn(Int) -> a, amount: Int, acc: List(a)) -> List(a) {
  case amount {
    amount if amount == 0 -> acc
    _ -> do_for(callback, amount - 1, [callback(amount), ..acc])
  }
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

pub type Model {
  Model(
    collisions: dict.Dict(#(Int, Int), Bool),
    start: #(Int, Int),
    end: #(Int, Int),
    hover: #(Int, Int),
    path: List(#(Int, Int)),
  )
}

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  #(
    Model(
      list.map(positions(), fn(a) {
        io.debug(a)
        #(#(a.0, a.1), a.2)
      })
        |> dict.from_list,
      start: #(0, 0),
      end: #(0, 0),
      hover: #(0, 0),
      path: [],
    ),
    effect.none(),
  )
}

pub type Msg {
  ToggleCollision(#(Int, Int))
  UpdateStartX(String)
  UpdateStartY(String)
  UpdateEndX(String)
  UpdateEndY(String)
  RecalculatePath
  UpdateHover(#(Int, Int))
}

@external(javascript, "./tekspes_ffi.mjs", "getCollisionsAsList")
fn get_collisions_as_string(value: List(a)) -> String

pub fn update(model: Model, msg: Msg) -> #(Model, effect.Effect(Msg)) {
  case msg {
    UpdateStartX(start_x) -> #(
      Model(
        ..model,
        start: #(int.parse(start_x) |> result.unwrap(0), model.start.1),
      ),
      effect.from(fn(dispatch) { dispatch(RecalculatePath) }),
    )
    UpdateStartY(start_y) -> #(
      Model(
        ..model,
        start: #(model.start.0, int.parse(start_y) |> result.unwrap(0)),
      ),
      effect.from(fn(dispatch) { dispatch(RecalculatePath) }),
    )
    UpdateEndX(end_x) -> #(
      Model(..model, end: #(int.parse(end_x) |> result.unwrap(0), model.end.1)),
      effect.from(fn(dispatch) { dispatch(RecalculatePath) }),
    )
    UpdateEndY(end_y) -> #(
      Model(..model, end: #(model.end.0, int.parse(end_y) |> result.unwrap(0))),
      effect.from(fn(dispatch) { dispatch(RecalculatePath) }),
    )
    RecalculatePath -> #(
      Model(
        ..model,
        path: gleamstar.a_star(
            model.start,
            model.end,
            dict.to_list(model.collisions) |> list.map(fn(a) { a.0 }),
          )
          |> result.unwrap([]),
      ),
      effect.none(),
    )
    UpdateHover(hover) -> #(Model(..model, hover:), effect.none())
    ToggleCollision(#(x, y)) -> {
      case dict.get(model.collisions, #(x, y)) {
        Ok(collision) -> {
          let collisions =
            dict.delete(model.collisions, #(x, y))
            |> dict.insert(#(x, y), !collision)
          #(Model(..model, collisions:), effect.none())
        }
        Error(_) -> {
          #(
            Model(
              ..model,
              collisions: dict.insert(model.collisions, #(x, y), True),
            ),
            effect.none(),
          )
        }
      }
    }
    _ -> #(model, effect.none())
  }
}

fn is_collision_toggled(
  collisions: dict.Dict(#(Int, Int), Bool),
  pos: #(Int, Int),
) -> Bool {
  case dict.get(collisions, pos) {
    Ok(a) -> a
    Error(_) -> False
  }
}

@external(javascript, "./tekspes_ffi.mjs", "getAttributeFromEventTarget")
fn get_attribute_from_event_target(
  event: dynamic.Dynamic,
  attribute: String,
) -> Result(String, Nil)

pub fn view(model: Model) -> element.Element(Msg) {
  html.div([attribute.class("flex flex-col")], [
    html.div([attribute.class("w-[2048px]")], [
      html.img([attribute.src("/priv/static/skolan.png")]),
      html.div(
        [attribute.class("absolute top-0 grid grid-cols-[repeat(128,16px)]")],
        for(128 * 35, fn(idx) {
          let x = idx % 128
          let y = float.floor(int.to_float(idx) /. 128.0) |> float.round
          html.div(
            [
              attribute.class(
                tw_merge([
                  "size-4 opacity-0",
                  case is_collision_toggled(model.collisions, #(x, y)) {
                    True -> "bg-red-100 opacity-80"
                    False -> "bg-blue-500 hover:opacity-50"
                  },
                  case model.path |> list.contains(#(x, y)) {
                    True -> "bg-green-100 opacity-80"
                    False -> ""
                  },
                ]),
              ),
              attribute.attribute("data-x", int.to_string(x)),
              attribute.attribute("data-y", int.to_string(y)),
              event.on("mouseenter", fn(event) {
                use x <- result.try(
                  result.replace_error(
                    get_attribute_from_event_target(event, "x"),
                    [],
                  ),
                )
                use y <- result.try(
                  result.replace_error(
                    get_attribute_from_event_target(event, "y"),
                    [],
                  ),
                )
                let assert Ok(x) = int.parse(x)
                let assert Ok(y) = int.parse(y)

                Ok(UpdateHover(#(x, y)))
              }),
              event.on("click", fn(event) {
                use x <- result.try(
                  result.replace_error(
                    get_attribute_from_event_target(event, "x"),
                    [],
                  ),
                )
                use y <- result.try(
                  result.replace_error(
                    get_attribute_from_event_target(event, "y"),
                    [],
                  ),
                )
                let assert Ok(x) = int.parse(x)
                let assert Ok(y) = int.parse(y)

                Ok(ToggleCollision(#(x, y)))
              }),
              // }),
            ],
            [],
          )
        }),
        // [],
      ),
    ]),
    html.text(
      "Hovering: "
      <> int.to_string(model.hover.0)
      <> ", "
      <> int.to_string(model.hover.1),
    ),
    html.div([attribute.class("grid grid-cols-[100px,1fr] w-[300px] gap-2")], [
      html.text("Start x"),
      html.input([event.on_input(UpdateStartX)]),
      html.text("Start y"),
      html.input([event.on_input(UpdateStartY)]),
      html.text("End x"),
      html.input([event.on_input(UpdateEndX)]),
      html.text("End y"),
      html.input([event.on_input(UpdateEndY)]),
    ]),
    list.map(model.path, fn(point) {
      int.to_string(point.0) <> ", " <> int.to_string(point.1)
    })
      |> string.join(" ")
      |> html.text,
    // list.map(
  //   model.collisions |> dict.to_list |> list.filter(fn(a) { a.1 == True }),
  //   fn(collision) {
  //     "["
  //     <> int.to_string(collision.0.0)
  //     <> ","
  //     <> int.to_string(collision.0.1)
  //     <> ","
  //     <> case collision.1 {
  //       True -> "true"
  //       False -> "false"
  //     }
  //     <> "]"
  //   },
  // )
  //   |> string.join(",")
  //   |> html.text,
  ])
  // html.div([], [])
}
