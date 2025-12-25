// Session 0.1 Roadmap Diagram
// Hand-drawn style using rough.js

import { createCanvas } from 'canvas';
import rough from 'roughjs';
import fs from 'fs';

// Configuration
const WIDTH = 1000;
const HEIGHT = 200;
const COLORS = {
  navy: '#13294B',      // Gillings navy
  carolina: '#4B9CD3',  // Carolina blue
  white: '#FFFFFF',
  cream: '#F5F4F0',
  lightBlue: '#7BB8E0'
};

const canvas = createCanvas(WIDTH, HEIGHT);
const ctx = canvas.getContext('2d');
const rc = rough.canvas(canvas);

// Background
ctx.fillStyle = COLORS.white;
ctx.fillRect(0, 0, WIDTH, HEIGHT);

// Topics for Session 0.1
const topics = [
  'Course\nOverview',
  'Assessment\n& Grading',
  'Causal\nInference',
  'Course\nFramework',
  'Next\nSteps'
];

const boxWidth = 140;
const boxHeight = 100;
const gap = 50;
const startX = 40;
const startY = (HEIGHT - boxHeight) / 2;

// Draw boxes and connections
topics.forEach((topic, i) => {
  const x = startX + i * (boxWidth + gap);

  // Draw connecting arrow (except for last box)
  if (i < topics.length - 1) {
    const arrowStartX = x + boxWidth;
    const arrowEndX = x + boxWidth + gap;
    const arrowY = startY + boxHeight / 2;

    // Arrow line
    rc.line(arrowStartX + 5, arrowY, arrowEndX - 15, arrowY, {
      stroke: COLORS.navy,
      strokeWidth: 2,
      roughness: 0.8
    });

    // Arrowhead
    rc.polygon([
      [arrowEndX - 15, arrowY - 8],
      [arrowEndX - 15, arrowY + 8],
      [arrowEndX - 5, arrowY]
    ], {
      fill: COLORS.navy,
      fillStyle: 'solid',
      stroke: COLORS.navy,
      roughness: 0.5
    });
  }

  // Draw rounded rectangle box
  rc.rectangle(x, startY, boxWidth, boxHeight, {
    fill: i === 2 ? COLORS.carolina : COLORS.cream, // Highlight Causal Inference
    fillStyle: 'solid',
    stroke: COLORS.navy,
    strokeWidth: 2,
    roughness: 1.2
  });

  // Draw text label
  ctx.fillStyle = i === 2 ? COLORS.white : COLORS.navy;
  ctx.font = 'bold 14px Arial';
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';

  // Handle multi-line text
  const lines = topic.split('\n');
  const lineHeight = 18;
  const textY = startY + boxHeight / 2 - (lines.length - 1) * lineHeight / 2;

  lines.forEach((line, lineIdx) => {
    ctx.fillText(line, x + boxWidth / 2, textY + lineIdx * lineHeight);
  });
});

// Add subtle title at top
ctx.fillStyle = COLORS.navy;
ctx.font = 'italic 12px Arial';
ctx.textAlign = 'left';
ctx.fillText("Session 0.1: Today's Journey", 40, 25);

// Save output
const buffer = canvas.toBuffer('image/png');
fs.writeFileSync('media/session-0-1-roadmap.png', buffer);
console.log('Roadmap saved to media/session-0-1-roadmap.png');
