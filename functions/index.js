/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onSchedule } = require("firebase-functions/v2/scheduler");
const { logger } = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

const linhas = {
  "Linha de Sintra": {
    "Sintra ↔ Rossio": [
      "Sintra", "Portela de Sintra", "Rio de Mouro", "Mercês", "Algueirão-Mem Martins",
      "Amadora", "Reboleira", "Benfica", "Campolide", "Rossio"
    ],
    "Sintra ↔ Oriente": [
      "Sintra", "Portela de Sintra", "Rio de Mouro", "Mercês", "Algueirão-Mem Martins",
      "Amadora", "Reboleira", "Benfica", "Sete Rios", "Entrecampos",
      "Roma-Areeiro", "Chelas", "Oriente"
    ],
    "Sintra ↔ Alverca": [
      "Sintra", "Portela de Sintra", "Rio de Mouro", "Mercês", "Algueirão-Mem Martins",
      "Amadora", "Reboleira", "Benfica", "Sete Rios", "Entrecampos",
      "Roma-Areeiro", "Chelas", "Oriente", "Sacavém", "Bobadela",
      "Santa Iria", "Póvoa", "Alverca"
    ]
  },

  "Linha de Cascais": {
    "Cais do Sodré ↔ Cascais": [
      "Cais do Sodré", "Santos", "Alcântara-Mar", "Belém", "Algés", "Cruz Quebrada",
      "Caxias", "Paço de Arcos", "Santo Amaro", "Oeiras", "Carcavelos", "Parede",
      "São João do Estoril", "Estoril", "Monte Estoril", "Cascais"
    ],
    "Cais do Sodré ↔ Oeiras": [
      "Cais do Sodré", "Santos", "Alcântara-Mar", "Belém", "Algés", "Cruz Quebrada",
      "Caxias", "Paço de Arcos", "Santo Amaro", "Oeiras"
    ]
  },

  "Linha da Azambuja": {
    "Santa Apolónia ↔ Azambuja": [
      "Santa Apolónia", "Oriente", "Sacavém", "Bobadela", "Santa Iria", "Póvoa",
      "Alverca", "Vila Franca de Xira", "Castanheira do Ribatejo", "Azambuja"
    ],
    "Alcântara-Terra ↔ Azambuja": [
      "Alcântara-Terra", "Campolide", "Sete Rios", "Entrecampos", "Roma-Areeiro", "Chelas",
      "Oriente", "Sacavém", "Bobadela", "Santa Iria", "Póvoa", "Alverca",
      "Vila Franca de Xira", "Castanheira do Ribatejo", "Azambuja"
    ],
    "Alcântara-Terra ↔ Castanheira": [
      "Alcântara-Terra", "Campolide", "Sete Rios", "Entrecampos", "Roma-Areeiro", "Chelas",
      "Oriente", "Sacavém", "Bobadela", "Santa Iria", "Póvoa", "Alverca",
      "Vila Franca de Xira", "Castanheira do Ribatejo"
    ]
  }
};

function generateTimeSequence(startTime, stationsCount, intervalMinutes = 5) {
  const times = [];
  let time = new Date(startTime);
  for (let i = 0; i < stationsCount; i++) {
    const hh = time.getHours().toString().padStart(2, "0");
    const mm = time.getMinutes().toString().padStart(2, "0");
    times.push(`${hh}:${mm}`);
    time.setMinutes(time.getMinutes() + intervalMinutes);
  }
  return times;
}

function generateTrainData(linhaName, varianteName, stations, sentido, startTime,id) {
  const temposChegada = generateTimeSequence(startTime, stations.length, 5);

  const numCarriages = 3 + Math.floor(Math.random() * 4);
  const lotacao = {};
  for (let i = 1; i <= numCarriages; i++) {
    lotacao[i.toString()] = Math.floor(Math.random() * 101);
  }
  const occupancyValues = Object.values(lotacao);
  const occupancyPercent =
    occupancyValues.reduce((a, b) => a + b, 0) / occupancyValues.length;

  return {
    id,
    linha: linhaName,
    variante: varianteName,
    sentido,
    estacaoOrigem: stations[0],
    estacaoDestino: stations[stations.length - 1],
    estacoes: stations,
    temposChegada: stations.map((estacao, idx) => ({
      estacao,
      tempo: temposChegada[idx],
    })),
    numCarriages,
    lotacao,
    occupancyPercent: Math.round(occupancyPercent),
    createdAt: admin.firestore.Timestamp.now(),
  };
}

let globalTrainId = 1;

async function generateTrainsBatch() {
  const batch = db.batch();
  const now = new Date();
  now.setHours(5, 0, 0, 0);
  const trainsPerVariant = 20;
  const spacingMinutes = 60; // 1 train per hour

  for (const [linhaName, variantes] of Object.entries(linhas)) {
    for (const [varianteName, stations] of Object.entries(variantes)) {
      for (let trainNum = 1; trainNum <= trainsPerVariant; trainNum++) {
        const startTimeIda = new Date(now.getTime() + trainNum * spacingMinutes * 60000);
        const idaData = generateTrainData(linhaName, varianteName, stations, "ida", startTimeIda, globalTrainId);
        const idaDocId = `${linhaName}_${varianteName}_ida_train${globalTrainId}`;
        batch.set(db.collection("Comboio").doc(idaDocId), idaData);
        globalTrainId++;

        const reversedStations = [...stations].reverse();
        const startTimeVolta = new Date(now.getTime() + trainNum * spacingMinutes * 60000);
        const voltaData = generateTrainData(linhaName, varianteName, reversedStations, "volta", startTimeVolta, globalTrainId);
        const voltaDocId = `${linhaName}_${varianteName}_volta_train${globalTrainId}`;
        batch.set(db.collection("Comboio").doc(voltaDocId), voltaData);
        globalTrainId++;
      }
    }
  }

  await batch.commit();
  logger.info("Trains generated successfully.");
}

async function clearComboioCollection() {
  const snapshot = await db.collection("Comboio").get();
  const batch = db.batch();
  snapshot.forEach((doc) => {
    batch.delete(doc.ref);
  });
  await batch.commit();
}

exports.scheduledTrainGenerator = onSchedule("every day 11:30", async (event) => {
  logger.info("Starting scheduled train generation");
  try {
    await clearComboioCollection(); // <-- delete old data
    await generateTrainsBatch();    // then generate new data
    logger.info("Train generation finished");
  } catch (e) {
    logger.error("Error generating trains:", e);
  }
});







// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
