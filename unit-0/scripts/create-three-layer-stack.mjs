// Three-Layer Causal Inference Stack - Excalidraw-style diagram
// Uses rough.js for hand-drawn aesthetic
import { createCanvas } from 'canvas';
import rough from 'roughjs';
import fs from 'fs';

// Configuration
const WIDTH = 900;
const HEIGHT = 550;
const COLORS = {
  navy: '#13294B',      // Gillings navy
  carolina: '#4B9CD3',  // Carolina blue
  white: '#FFFFFF',
  cream: '#FDF6E3',
  lightBlue: '#7BB8E0',
  decision: '#e6ffe6',  // Light green for Layer 3
  estimation: '#fff2e6', // Light orange for Layer 2
  identification: '#e6f3ff' // Light blue for Layer 1
};

const canvas = createCanvas(WIDTH, HEIGHT);
const ctx = canvas.getContext('2d');
const rc = rough.canvas(canvas);

// Background
ctx.fillStyle = COLORS.white;
ctx.fillRect(0, 0, WIDTH, HEIGHT);

// Box dimensions
const boxWidth = 700;
const boxHeight = 130;
const startX = (WIDTH - boxWidth) / 2;
const gap = 25;

// Helper function to draw a layer box
function drawLayerBox(y, fillColor, title, items) {
  // Main box
  rc.rectangle(startX, y, boxWidth, boxHeight, {
    fill: fillColor,
    fillStyle: 'solid',
    stroke: COLORS.navy,
    strokeWidth: 2.5,
    roughness: 1.2
  });

  // Title
  ctx.fillStyle = COLORS.navy;
  ctx.font = 'bold 24px Arial';
  ctx.textAlign = 'center';
  ctx.fillText(title, WIDTH/2, y + 35);

  // Items
  ctx.font = '16px Arial';
  ctx.fillStyle = COLORS.navy;
  items.forEach((item, i) => {
    ctx.fillText(item, WIDTH/2, y + 65 + (i * 22));
  });
}

// Helper function to draw an arrow
function drawArrow(fromY, toY) {
  const midX = WIDTH / 2;

  // Arrow line
  rc.line(midX, fromY, midX, toY - 10, {
    stroke: COLORS.navy,
    strokeWidth: 2.5,
    roughness: 1
  });

  // Arrowhead
  rc.polygon([
    [midX - 12, toY - 20],
    [midX + 12, toY - 20],
    [midX, toY - 2]
  ], {
    fill: COLORS.navy,
    fillStyle: 'solid',
    stroke: COLORS.navy,
    roughness: 0.8
  });
}

// Layer 1: Identification (bottom)
const layer1Y = 380;
drawLayerBox(layer1Y, COLORS.identification, 'Layer 1: IDENTIFICATION', [
  'What assumptions justify causal claims?',
  'RCTs, Natural experiments, DAGs, Potential outcomes'
]);

// Arrow from Layer 1 to Layer 2
drawArrow(layer1Y - 5, layer1Y - gap + 5);

// Layer 2: Estimation (middle)
const layer2Y = layer1Y - boxHeight - gap - 10;
drawLayerBox(layer2Y, COLORS.estimation, 'Layer 2: ESTIMATION', [
  'How do we estimate effects?',
  'Double ML, Causal Forests, Doubly-robust methods'
]);

// Arrow from Layer 2 to Layer 3
drawArrow(layer2Y - 5, layer2Y - gap + 5);

// Layer 3: Decision (top)
const layer3Y = layer2Y - boxHeight - gap - 10;
drawLayerBox(layer3Y, COLORS.decision, 'Layer 3: DECISION', [
  'What should we do?',
  'Policy learning, Optimal treatment rules'
]);

// Title at top
ctx.fillStyle = COLORS.navy;
ctx.font = 'bold 20px Arial';
ctx.textAlign = 'center';
ctx.fillText('The Three-Layer Causal Inference Stack', WIDTH/2, 25);

// Save output
const buffer = canvas.toBuffer('image/png');
const outputPath = new URL('../images/three-layer-stack.png', import.meta.url).pathname;
fs.writeFileSync(outputPath, buffer);
console.log('Diagram saved to', outputPath);
