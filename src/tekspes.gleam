import glailwind_merge.{tw_merge}
import gleam/dict
import gleam/dynamic
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
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
  Model(collisions: dict.Dict(#(Int, Int), Bool))
}

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  #(
    Model(
      list.map(positions(), fn(a) {
        io.debug(a)
        #(#(a.0, a.1), a.2)
      })
      |> dict.from_list,
    ),
    effect.none(),
  )
}

pub type Msg {
  ToggleCollision(#(Int, Int))
}

@external(javascript, "./tekspes_ffi.mjs", "getCollisionsAsList")
fn get_collisions_as_string(value: List(a)) -> String

pub fn update(model: Model, msg: Msg) -> #(Model, effect.Effect(Msg)) {
  case msg {
    ToggleCollision(#(x, y)) -> {
      case dict.get(model.collisions, #(x, y)) {
        Ok(collision) -> {
          let collisions =
            dict.delete(model.collisions, #(x, y))
            |> dict.insert(#(x, y), !collision)
          #(Model(collisions:), effect.none())
        }
        Error(_) -> {
          #(
            Model(collisions: dict.insert(model.collisions, #(x, y), True)),
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
                  "size-4 opacity-0 hover:opacity-50 bg-blue-500",
                  case is_collision_toggled(model.collisions, #(x, y)) {
                    True -> "bg-red-100 opacity-80"
                    False -> ""
                  },
                ]),
              ),
              attribute.attribute("data-x", int.to_string(x)),
              attribute.attribute("data-y", int.to_string(y)),
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
            ],
            [],
          )
        }),
        // [],
      ),
    ]),
    html.text(get_collisions_as_string(dict.to_list(model.collisions))),
  ])
  // html.div([], [])
}
