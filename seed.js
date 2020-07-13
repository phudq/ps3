const fs = require('fs');

const stations = [
  [1, 'Ha Noi', 21.024226, 105.841101],
  [2, 'Ninh Binh', 20.241969, 105.974341],
  [3, 'Vinh', 18.688025, 105.664045],
  [4, 'Dong Hoi', 17.468606, 106.599825],
  [5, 'Hue', 16.456475, 107.577234],
  [6, 'Da Nang', 16.071524, 108.208859],
  [7, 'Quang Ngai', 15.120833, 108.780954],
  [8, 'Quy Nhon', 13.777948, 109.224854],
  [9, 'Tuy Hoa', 13.087900, 109.297311],
  [10, 'Nha Trang', 12.248599, 109.183872],
  [11, 'Thap Cham', 11.599005, 108.950345],
  [12, 'Binh Thuan', 10.968427, 108.003111],
  [13, 'Sai Gon', 10.782201, 106.677251]
]

const trains = [
  [1, 'SE1', '6,30', [1,1,1,1,2,2,2]],
  [2, 'SE3', '6,45', [2,2,2,2,2,3,3]],
  [3, 'SP1', '7,30', [1,1,1,1,3,3,3]],
  [4, 'SQ3', '8,00', [2,2,2,2,3,3,3]],
  [5, 'LC3', '6,00', [2,2,2,2,2,2,2]],
  [6, 'HP1', '6,45', [1,1,1,1,1,1,1]],
  [7, 'LP3', '7,00', [2,2,2,3,3,3,3]],
  [8, 'LP5', '7,45', [1,1,1,3,3,3,3]],
  [9, 'HP3', '6,30', [2,2,2,2,1,1,1]],
  [10, 'HP5', '6,45', [2,2,2,3,3,3,3]]
];

const trainsDetails = trains.reduce((acm, el) => {
  const id = el[0];
  const code = el[1];
  const [h, m] = el[2].split(',');
  const tranCarTypes = el[3];
  const startTime = parseInt(h) * 60 * 60 * 1000 + parseInt(m) * 60 * 1000;
  acm[id] = { id, code, startTime, tranCarTypes }
  return acm;
}, {})

const stationDetails = stations.reduce((acm, current) => {
  const id = current[0];
  const name = current[1];
  const lat = current[2];
  const lon = current[3];
  acm[id] = {
    id, name, lat, lon
  }
  return acm;
}, {});

const trainCar = {
  1: [16*4, [1,2]],
  2: [16*4, [3,4]],
  3: [16*2, [5,6]],
}

function seedSeat() {
  let re = [];
  for (const key in trainCar) {
    const num = trainCar[key][0];
    const seatTypes = trainCar[key][1];
    for (let index = 1; index <= num; index++) {
      const rand = Math.round(Math.random())
      const item = `(${index}, ${seatTypes[rand]}, 1, '06/20/2020'),\n`
      re.push(item);
    }
  }
  return re;
}

function seedTrainCar(params) {
  var re = [];
  for (const idTrain in trainsDetails) {
    const train = trainsDetails[idTrain];
    for (const [index, idTrainCarType] of train.tranCarTypes.entries()) {
      const item = `(${idTrain}, ${idTrainCarType}, ${index + 1}, 1,'6/20/2020'),\n`;
      re.push(item);
    }
  }
  return re;
}

const trainStation = {
  1: [1, 4, 7, 8, 10, 11, 12, 13],
  2: [4, 5, 6, 7, 8, 9],
  3: [1, 2, 5, 6, 8],
  4: [8, 10, 12, 12],
  5: [3, 5, 6, 7, 8, 9],
  6: [13, 11, 10, 8, 7, 5, 4, 3, 1],
  7: [9, 8, 5, 4, 2, 1],
  8: [5, 4, 3, 2, 1],
  9: [8, 6, 4, 2],
  10: [13, 12, 11, 10],
}

function seedTrainStation() {
  var re = [];
  var i = 1;

  for (const idTrain in trainStation) {
    const trainStations = trainStation[idTrain];
    let startTime = trainsDetails[idTrain].startTime;
    for (const [index, idStation] of trainStations.entries()) {
      const prev = stationDetails[idStation - 1];
      const station = stationDetails[idStation];
      const distance = getDistance(station, prev);
      const arrivalTime = getArrivalTime(distance, startTime);
      startTime = arrivalTime;
      const item = `(${i}, ${idTrain}, ${idStation}, ${index}, ${distance}, ${arrivalTime}, 1, '6/20/2020'),\n`
      i++;
      re.push(item);
    }
  }
  return re;
}

function getDistance(station, prev) {
  if (!prev) {
    return 0;
  }
  const { lat: lat1, lon: lon1 } = station;
  const { lat: lat2, lon: lon2 } = prev;

  const R = 6371e3; // metres
  const φ1 = lat1 * Math.PI / 180; // φ, λ in radians
  const φ2 = lat2 * Math.PI / 180;
  const Δφ = (lat2 - lat1) * Math.PI / 180;
  const Δλ = (lon2 - lon1) * Math.PI / 180;

  const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) *
    Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  const d = R * c; //
  return Math.round(d);
}

function getArrivalTime(distance, startTime) {
  const kmh = 60;
  const time = startTime + distance * ((60 * 60 * 1000) / (kmh * 1000));
  return time;
}

// fs.writeFileSync('./a.txt', seedTrainStation().join(''));
fs.writeFileSync('./b.txt', seedTrainCar().join(''))
// fs.writeFileSync('./c.txt', seedSeat().join(''))