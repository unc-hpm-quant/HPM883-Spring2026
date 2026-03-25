"""Generate causal tree/forest illustration figures for Session 3.0"""

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import matplotlib.patheffects as pe
import numpy as np

plt.rcParams.update({
    'font.family': 'sans-serif',
    'font.sans-serif': ['Helvetica', 'Arial', 'DejaVu Sans'],
    'font.size': 13,
    'figure.facecolor': 'white',
})

CAROLINA_BLUE = '#4B9CD3'
NAVY = '#13294B'
LIGHT_BLUE = '#7BB8E0'
CREAM = '#F5F4F0'
WARM_GRAY = '#B0A99F'
ORANGE = '#E07C3E'
GREEN = '#2E8B57'
RED = '#C44E52'


def draw_rounded_box(ax, xy, width, height, text, color, text_color=None,
                     fontsize=12, fontweight='normal', alpha=0.25, lw=2):
    """Draw a rounded rectangle with centered text."""
    if text_color is None:
        text_color = NAVY
    box = mpatches.FancyBboxPatch(
        xy, width, height,
        boxstyle="round,pad=0.08",
        facecolor=color, edgecolor=NAVY, linewidth=lw, alpha=alpha
    )
    ax.add_patch(box)
    border = mpatches.FancyBboxPatch(
        xy, width, height,
        boxstyle="round,pad=0.08",
        facecolor='none', edgecolor=color, linewidth=lw
    )
    ax.add_patch(border)
    cx = xy[0] + width / 2
    cy = xy[1] + height / 2
    ax.text(cx, cy, text, ha='center', va='center',
            fontsize=fontsize, fontweight=fontweight, color=text_color)


def arrow(ax, start, end, color=NAVY, lw=1.5):
    ax.annotate('', xy=end, xytext=start,
                arrowprops=dict(arrowstyle='->', color=color, lw=lw))


# ── Figure 1: Prediction Tree vs Causal Tree ───────────────────
def make_tree_comparison():
    fig, axes = plt.subplots(1, 2, figsize=(12, 5.5))

    for idx, (ax, title, leaf_vals, leaf_colors, split_labels) in enumerate(zip(
        axes,
        ['Prediction Tree', 'Causal Tree'],
        [
            [r'$\bar{Y}$ = 8.2', r'$\bar{Y}$ = 3.1', r'$\bar{Y}$ = 5.7', r'$\bar{Y}$ = 6.9'],
            [r'$\hat{\tau}$ = -0.3', r'$\hat{\tau}$ = -2.8', r'$\hat{\tau}$ = -0.5', r'$\hat{\tau}$ = -3.1']
        ],
        [
            [LIGHT_BLUE, LIGHT_BLUE, LIGHT_BLUE, LIGHT_BLUE],
            [WARM_GRAY, ORANGE, WARM_GRAY, ORANGE]
        ],
        [
            ['Age > 55', 'Income > $40K', 'Rural'],
            ['Comorbidities > 2', 'Age > 55', 'Female']
        ]
    )):
        ax.set_xlim(0, 10)
        ax.set_ylim(0, 7)
        ax.axis('off')
        ax.set_title(title, fontsize=16, fontweight='bold', color=NAVY, pad=10)

        # Root node
        draw_rounded_box(ax, (3.5, 5.8), 3, 0.9, split_labels[0],
                        CAROLINA_BLUE if idx == 0 else GREEN,
                        fontsize=11, fontweight='bold', alpha=0.3)

        # Level 1 nodes
        draw_rounded_box(ax, (1, 3.8), 2.5, 0.8, split_labels[1],
                        CAROLINA_BLUE if idx == 0 else GREEN,
                        fontsize=10, alpha=0.2)
        draw_rounded_box(ax, (6.5, 3.8), 2.5, 0.8, split_labels[2],
                        CAROLINA_BLUE if idx == 0 else GREEN,
                        fontsize=10, alpha=0.2)

        # Arrows from root
        arrow(ax, (4.2, 5.8), (2.25, 4.6))
        arrow(ax, (5.8, 5.8), (7.75, 4.6))

        # Labels on arrows
        ax.text(2.8, 5.35, 'Yes', fontsize=9, color=WARM_GRAY, ha='center')
        ax.text(7.2, 5.35, 'No', fontsize=9, color=WARM_GRAY, ha='center')

        # Leaf nodes
        leaf_positions = [(0.2, 1.8), (2.8, 1.8), (5.7, 1.8), (7.8, 1.8)]
        leaf_widths = [2.2, 2.2, 1.8, 2.0]

        for i, (pos, w, val, col) in enumerate(zip(
            leaf_positions, leaf_widths, leaf_vals, leaf_colors
        )):
            draw_rounded_box(ax, pos, w, 1.2, val, col,
                            fontsize=11, fontweight='bold', alpha=0.3, lw=2.5)

        # Arrows to leaves
        arrow(ax, (1.5, 3.8), (1.3, 3.0))
        arrow(ax, (2.8, 3.8), (3.9, 3.0))
        arrow(ax, (7.0, 3.8), (6.6, 3.0))
        arrow(ax, (8.3, 3.8), (8.8, 3.0))

        # Leaf labels
        if idx == 0:
            ax.text(5, 0.7, 'Leaves predict outcomes',
                    ha='center', fontsize=11, color=WARM_GRAY, style='italic')
        else:
            ax.text(5, 0.7, 'Leaves estimate treatment effects',
                    ha='center', fontsize=11, color=ORANGE, style='italic',
                    fontweight='bold')

    plt.tight_layout()
    plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/tree-comparison.png',
                dpi=200, bbox_inches='tight', facecolor='white')
    plt.close()
    print("Done: tree-comparison.png")


# ── Figure 2: Honest Splitting Flow ────────────────────────────
def make_honest_flow():
    fig, ax = plt.subplots(1, 1, figsize=(11, 6))
    ax.set_xlim(0, 11)
    ax.set_ylim(0, 7)
    ax.axis('off')

    # Title
    ax.text(5.5, 6.7, 'Honest Estimation: Two-Stage Process',
            ha='center', fontsize=16, fontweight='bold', color=NAVY)

    # Stage 1: Splitting sample builds tree
    ax.text(2.5, 6.1, 'Stage 1: Build Structure',
            ha='center', fontsize=13, fontweight='bold', color=CAROLINA_BLUE)

    # Splitting sample box
    draw_rounded_box(ax, (0.5, 4.8), 4, 0.9, 'Splitting Sample (S)',
                    CAROLINA_BLUE, fontsize=12, fontweight='bold', alpha=0.25)

    # Mini tree from splitting
    # Root
    ax.plot([2.5, 1.5], [4.5, 3.8], color=CAROLINA_BLUE, lw=2)
    ax.plot([2.5, 3.5], [4.5, 3.8], color=CAROLINA_BLUE, lw=2)
    ax.plot([1.5, 1.0], [3.8, 3.1], color=CAROLINA_BLUE, lw=1.5)
    ax.plot([1.5, 2.0], [3.8, 3.1], color=CAROLINA_BLUE, lw=1.5)
    ax.plot([3.5, 3.0], [3.8, 3.1], color=CAROLINA_BLUE, lw=1.5)
    ax.plot([3.5, 4.0], [3.8, 3.1], color=CAROLINA_BLUE, lw=1.5)

    # Leaf boxes (empty - just structure)
    for x in [0.6, 1.6, 2.6, 3.6]:
        box = mpatches.FancyBboxPatch(
            (x, 2.6), 0.8, 0.5,
            boxstyle="round,pad=0.05",
            facecolor=CREAM, edgecolor=CAROLINA_BLUE, linewidth=1.5
        )
        ax.add_patch(box)
        ax.text(x + 0.4, 2.85, '?', ha='center', va='center',
                fontsize=14, color=CAROLINA_BLUE, fontweight='bold')

    ax.text(2.5, 2.0, 'Tree structure only\n(no estimates yet)',
            ha='center', fontsize=10, color=WARM_GRAY, style='italic')

    # Big arrow in the middle
    ax.annotate('', xy=(6.2, 3.5), xytext=(5.2, 3.5),
                arrowprops=dict(arrowstyle='->', color=NAVY, lw=3))
    ax.text(5.7, 3.9, 'Pass\nthrough', ha='center', fontsize=9, color=NAVY)

    # Stage 2: Estimation sample fills leaves
    ax.text(8.5, 6.1, 'Stage 2: Estimate Effects',
            ha='center', fontsize=13, fontweight='bold', color=ORANGE)

    # Estimation sample box
    draw_rounded_box(ax, (6.5, 4.8), 4, 0.9, 'Estimation Sample (E)',
                    ORANGE, fontsize=12, fontweight='bold', alpha=0.2)

    # Same tree structure
    ax.plot([8.5, 7.5], [4.5, 3.8], color=NAVY, lw=2)
    ax.plot([8.5, 9.5], [4.5, 3.8], color=NAVY, lw=2)
    ax.plot([7.5, 7.0], [3.8, 3.1], color=NAVY, lw=1.5)
    ax.plot([7.5, 8.0], [3.8, 3.1], color=NAVY, lw=1.5)
    ax.plot([9.5, 9.0], [3.8, 3.1], color=NAVY, lw=1.5)
    ax.plot([9.5, 10.0], [3.8, 3.1], color=NAVY, lw=1.5)

    # Leaf boxes (filled with estimates)
    leaf_vals = ['-0.3', '-2.8', '-0.5', '-3.1']
    leaf_cols = [WARM_GRAY, ORANGE, WARM_GRAY, ORANGE]
    for x, val, col in zip([6.6, 7.6, 8.6, 9.6], leaf_vals, leaf_cols):
        box = mpatches.FancyBboxPatch(
            (x, 2.6), 0.8, 0.5,
            boxstyle="round,pad=0.05",
            facecolor=col, edgecolor=NAVY, linewidth=1.5, alpha=0.3
        )
        ax.add_patch(box)
        border = mpatches.FancyBboxPatch(
            (x, 2.6), 0.8, 0.5,
            boxstyle="round,pad=0.05",
            facecolor='none', edgecolor=col, linewidth=1.5
        )
        ax.add_patch(border)
        ax.text(x + 0.4, 2.85, val, ha='center', va='center',
                fontsize=11, color=NAVY, fontweight='bold')

    ax.text(8.5, 2.0, 'Fresh data fills leaves\nwith unbiased estimates',
            ha='center', fontsize=10, color=ORANGE, style='italic',
            fontweight='bold')

    # Bottom callout
    callout = mpatches.FancyBboxPatch(
        (1.5, 0.3), 8, 1.2,
        boxstyle="round,pad=0.1",
        facecolor=CREAM, edgecolor=NAVY, linewidth=1.5
    )
    ax.add_patch(callout)
    ax.text(5.5, 0.9,
            'Key insight: The estimation sample never saw the splits.\n'
            'So leaf estimates are unbiased -- no overfitting to tree structure.',
            ha='center', va='center', fontsize=11, color=NAVY)

    plt.tight_layout()
    plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/honest-flow.png',
                dpi=200, bbox_inches='tight', facecolor='white')
    plt.close()
    print("Done: honest-flow.png")


# ── Figure 3: CATE Distribution Example ────────────────────────
def make_cate_distribution():
    fig, ax = plt.subplots(1, 1, figsize=(9, 4.5))

    np.random.seed(883)
    # Simulate bimodal CATE distribution
    n1 = 600
    n2 = 400
    tau1 = np.random.normal(-0.5, 0.8, n1)   # low-benefit group
    tau2 = np.random.normal(-2.5, 0.7, n2)   # high-benefit group
    tau = np.concatenate([tau1, tau2])
    ate = np.mean(tau)

    ax.hist(tau, bins=50, color=CAROLINA_BLUE, alpha=0.7, edgecolor='white', lw=0.5)
    ax.axvline(x=ate, color=ORANGE, lw=2.5, linestyle='--', label=f'ATE = {ate:.1f}')
    ax.axvline(x=0, color=NAVY, lw=1, linestyle=':', alpha=0.5)

    # Annotate regions
    ax.annotate('Low-benefit\ngroup',
                xy=(-0.5, 55), fontsize=11, color=WARM_GRAY,
                ha='center', fontweight='bold')
    ax.annotate('High-benefit\ngroup',
                xy=(-2.5, 45), fontsize=11, color=NAVY,
                ha='center', fontweight='bold')

    ax.set_xlabel(r'Estimated CATE: $\hat{\tau}(x)$', fontsize=13)
    ax.set_ylabel('Count', fontsize=13)
    ax.set_title('Distribution of Individual Treatment Effects',
                fontsize=15, fontweight='bold', color=NAVY)
    ax.legend(fontsize=12, loc='upper left')
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    # Add text annotation
    ax.text(0.97, 0.95,
            'The ATE hides two\ndistinct subpopulations',
            transform=ax.transAxes, ha='right', va='top',
            fontsize=10, color=WARM_GRAY, style='italic',
            bbox=dict(boxstyle='round,pad=0.3', facecolor=CREAM, edgecolor=WARM_GRAY, alpha=0.8))

    plt.tight_layout()
    plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/cate-distribution.png',
                dpi=200, bbox_inches='tight', facecolor='white')
    plt.close()
    print("Done: cate-distribution.png")


if __name__ == '__main__':
    make_tree_comparison()
    make_honest_flow()
    make_cate_distribution()
    print("\nAll tree figures generated!")
