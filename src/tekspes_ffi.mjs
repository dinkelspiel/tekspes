import { Ok, Error } from "./gleam.mjs";

export const getAttributeFromEventTarget = (event, attribute) => {
  if (Object.keys(event.target.dataset).includes(attribute)) {
    return new Ok(event.target.dataset[attribute]);
  } else {
    return new Error(undefined);
  }
};

export const getCollisionsAsList = (value) => {
  value = JSON.parse(JSON.stringify(value));
  let acc = [];
  while (JSON.stringify(value) !== "{}") {
    if (!value.head[1]) {
      continue;
    }

    acc.push([value.head[0][0], value.head[0][1], value.head[1]]);
    value = value.tail;
  }
  return acc;
};

export const wierdToNormal = () => {
  let wierd =
    "33,8,true,32,8,true,81,5,true,49,12,true,116,4,true,118,4,true,117,4,true,119,4,true,85,12,false,86,12,true,84,12,true,46,26,true,109,15,true,32,19,true,58,8,true,59,8,true,31,18,true,76,11,true,78,11,true,79,11,true,77,11,true,125,18,true,30,17,true,42,6,true,29,16,true,121,17,false,123,17,false,120,17,false,122,17,false,107,8,true,104,8,true,106,8,true,55,17,true,64,22,true,65,22,true,49,15,true,26,8,true,58,19,true,59,19,true,39,7,true,115,21,true,84,15,true,86,15,false,85,15,false,87,15,true,26,19,true,46,8,true,47,8,true,109,5,true,58,11,true,59,11,true,126,6,true,125,6,true,127,6,true,116,22,true,82,2,false,81,2,true,52,22,false,53,22,true,50,21,false,51,21,true,40,1,true,41,1,true,49,20,true,20,8,true,82,8,true,81,8,true,83,8,true,105,11,true,104,11,true,34,8,true,35,8,true,29,7,false,125,17,true,124,17,false,121,16,false,123,16,false,120,16,false,122,16,false,121,4,true,123,4,true,120,4,true,122,4,true,36,20,true,88,12,true,122,1,false,123,1,true,15,8,true,35,19,true,46,25,true,60,8,true,61,8,true,81,11,true,80,11,true,82,11,true,45,6,false,61,19,true,60,19,true,108,8,true,109,8,true,109,2,false,78,6,true,55,16,true,125,10,true,65,21,true,50,15,true,51,15,true,39,3,true,27,8,true,117,21,true,88,15,false,113,20,false,114,20,true,15,11,true,0,6,true,48,8,true,49,8,true,61,11,true,60,11,true,82,14,true,42,29,true,43,29,true,41,28,true,54,22,true,55,22,true,125,13,true,42,4,true,52,21,true,42,1,true,50,20,true,21,8,true,85,8,true,87,8,true,84,8,true,86,8,true,36,8,true,37,8,true,49,11,true,18,16,false,22,20,false,124,16,false,125,16,true,127,4,true,124,1,true,36,19,true,39,5,true,62,8,true,63,8,true,34,18,true,35,18,true,86,11,true,84,11,true,85,11,true,47,24,true,108,14,true,33,17,true,28,8,true,62,19,true,63,19,true,49,14,true,81,6,true,52,15,true,53,15,true,65,20,true,42,7,true,40,27,true,39,26,true,118,20,true,50,8,true,51,8,true,27,18,true,113,19,true,62,11,true,63,11,true,85,14,false,84,14,true,86,14,true,111,18,false,56,22,true,57,22,true,22,8,true,123,3,true,88,8,true,90,8,true,89,8,true,91,8,true,125,7,true,79,1,true,78,1,true,22,19,true,39,8,true,38,8,true,21,18,true,50,11,true,51,11,true,38,2,false,39,2,true,20,17,true,19,16,true,109,6,true,24,21,true,78,4,true,17,15,false,23,20,true,107,13,true,16,8,true,65,8,true,67,8,true,64,8,true,66,8,true,89,11,true,91,11,true,88,11,true,90,11,true,34,17,true,47,23,true,29,8,true,65,19,true,64,19,true,54,15,true,55,15,true,125,9,true,42,3,true,45,7,false,44,7,false,38,25,true,53,8,true,52,8,true,119,19,true,116,19,true,64,11,true,66,11,true,65,11,true,67,11,true,37,24,true,88,14,true,112,18,true,115,18,true,15,10,true,111,17,true,82,13,true,44,28,true,20,29,false,19,28,false,59,22,true,58,22,true,78,7,true,23,32,false,125,12,true,22,31,false,23,8,true,126,3,true,93,8,true,95,8,true,92,8,true,94,8,true,21,30,false,80,1,true,81,1,true,16,14,false,52,11,true,53,11,true,15,13,false,0,7,true,82,16,true,83,16,true,18,15,true,81,4,true,125,15,true,17,8,true,42,5,true,70,8,true,68,8,true,69,8,true,71,8,true,92,11,true,94,11,true,93,11,true,95,11,true,30,8,true,123,2,true,49,13,true,110,16,true,45,27,true,110,4,true,109,4,false,111,4,true,108,1,false,109,1,false,78,3,true,54,8,true,55,8,true,120,19,true,122,19,true,121,19,true,123,19,true,69,11,true,71,11,true,68,11,true,70,11,true,116,18,true,28,17,true,36,23,true,39,6,true,115,17,true,114,17,true,35,22,true,84,13,true,86,13,true,85,13,false,96,8,true,98,8,true,97,8,true,99,8,true,20,28,false,60,22,true,61,22,true,81,7,true,24,33,false,24,8,true,55,19,true,25,20,true,17,14,true,42,8,true,43,8,true,55,11,true,54,11,true,42,2,true,84,16,true,48,22,true,106,12,true,18,8,true,45,5,false,72,8,true,74,8,true,75,8,true,73,8,true,97,11,true,99,11,true,96,11,true,98,11,true,31,8,true,78,5,true,125,8,true,125,2,true,109,7,true,88,13,true,114,16,true,15,9,true,0,5,false,34,21,true,113,4,true,115,4,true,114,4,true,112,4,true,33,20,true,82,12,true,81,3,true,56,8,true,57,8,true,125,19,true,127,19,false,126,19,false,124,19,true,72,11,true,74,11,true,73,11,true,75,11,true,29,17,false,103,8,true,101,8,true,100,8,true,102,8,true,54,18,false,55,18,true,125,11,true,62,22,true,63,22,true,25,8,true,56,19,true,57,19,true,82,15,true,44,8,true,45,8,true,56,11,true,57,11,true,16,13,true,15,12,true,51,22,false,39,4,true,48,21,true,39,1,true,19,8,true,109,3,false,77,8,true,76,8,true,78,8,true,100,11,true,102,11,true,101,11,true,103,11,true,125,14,true,78,2,true".split(
      ","
    );
  let acc = [];
  while (wierd.length > 0) {
    let a = parseInt(wierd[0]);
    let b = parseInt(wierd[1]);
    let c = wierd[2] == "true";
    acc.push([a, b, c]);
    wierd = wierd.slice(3);
  }
  let acc2 = "[";
  while (acc.length > 0) {
    console.log(acc[0]);
    acc2 += `#(#(${(acc[0][0], acc[0][1])}), ${acc[0][2]})`;
    acc.pop();
  }
  return JSON.stringify(acc2);
};
