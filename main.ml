(*
 * Copyright © 2023 Sam Henke
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 *)

open Base


let parse_cube_count cube_count =
    Stdlib.Scanf.sscanf
        (String.strip cube_count)
        "%u %s"
        (fun count color -> color, count)

let parse_selection selection =
    String.split ~on:',' selection |> List.map ~f:parse_cube_count

let parse_selections selections =
    String.split ~on:';' selections |> List.map ~f:parse_selection

let parse_game line =
    let game_str, selections =
        match String.split ~on:':' line with
        | [game_str; selections] -> game_str, selections
        | _ -> assert false
    in
    let game_number = Stdlib.Scanf.sscanf game_str "Game %u" (fun x -> x) in
    (game_number, parse_selections selections)

let selection_is_valid selection =
    let color_count color =
        match List.Assoc.find selection ~equal:String.equal color with
        | Some c -> c
        | None -> 0
    in
    color_count "red" <= 12 &&
    color_count "green" <= 13 &&
    color_count "blue" <= 14

let () =
    let valid_game (game_number, selections) =
        if List.for_all ~f:selection_is_valid selections
        then Some game_number
        else None
    in
    In_channel.input_lines In_channel.stdin
    |> List.map ~f:parse_game
    |> List.filter_map ~f:valid_game
    |> List.reduce_exn ~f:(+)
    |> Stdlib.print_int
    |> Stdlib.print_newline
