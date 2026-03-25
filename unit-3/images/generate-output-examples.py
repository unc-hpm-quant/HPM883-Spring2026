"""Generate example R output images for Part 3 slides"""

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

plt.rcParams.update({
    'font.family': 'monospace',
    'font.size': 12,
    'figure.facecolor': 'white',
})

NAVY = '#13294B'
CAROLINA_BLUE = '#4B9CD3'
ORANGE = '#E07C3E'
CREAM = '#F5F4F0'
WARM_GRAY = '#B0A99F'


def make_calibration_output():
    """Simulated test_calibration() output as a formatted table image."""
    fig, ax = plt.subplots(1, 1, figsize=(8, 2.8))
    ax.axis('off')

    header = "> test_calibration(cf)"
    lines = [
        "",
        "Best linear fit using forest predictions (on held-out data)",
        "as well as the mean forest prediction as regressors, OOB:",
        "",
        "                               Estimate  Std. Error  t value  Pr(>|t|)",
        "mean.forest.prediction           1.0352      0.0634   16.33   < 2e-16 ***",
        "differential.forest.prediction   0.9814      0.1247    7.87   4.2e-15 ***",
        "---",
        'Signif. codes:  0 "***" 0.001 "**" 0.01 "*" 0.05 "." 0.1 " " 1',
    ]

    text = header + "\n" + "\n".join(lines)
    ax.text(0.02, 0.98, text, transform=ax.transAxes,
            fontsize=9.5, fontfamily='monospace', va='top', ha='left',
            color=NAVY,
            bbox=dict(boxstyle='round,pad=0.4', facecolor='#F8F8F8',
                     edgecolor='#CCCCCC', linewidth=1))

    plt.tight_layout()
    plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/output-calibration.png',
                dpi=200, bbox_inches='tight', facecolor='white')
    plt.close()
    print("Done: output-calibration.png")


def make_varimp_output():
    """Variable importance bar chart output."""
    plt.rcParams.update({'font.family': 'sans-serif', 'font.size': 13})

    fig, ax = plt.subplots(1, 1, figsize=(7, 3.5))

    variables = ['comorbidities', 'age', 'prior_er_visits', 'female', 'income_quartile', 'rural']
    importance = [0.38, 0.29, 0.14, 0.09, 0.06, 0.04]

    colors = [ORANGE if v > 0.2 else CAROLINA_BLUE if v > 0.1 else WARM_GRAY
              for v in importance]

    y_pos = np.arange(len(variables))
    ax.barh(y_pos, importance, color=colors, alpha=0.7, edgecolor=NAVY, linewidth=1)
    ax.set_yticks(y_pos)
    ax.set_yticklabels(variables, fontsize=11)
    ax.set_xlabel('Importance (weighted split frequency)', fontsize=11)
    ax.set_title('variable_importance(cf)', fontsize=13, fontweight='bold',
                color=NAVY, fontfamily='monospace')
    ax.invert_yaxis()
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    plt.tight_layout()
    plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/output-varimp.png',
                dpi=200, bbox_inches='tight', facecolor='white')
    plt.close()
    print("Done: output-varimp.png")


def make_blp_output():
    """Simulated best_linear_projection() output."""
    plt.rcParams.update({'font.family': 'monospace', 'font.size': 12})

    fig, ax = plt.subplots(1, 1, figsize=(8, 2.5))
    ax.axis('off')

    header = "> best_linear_projection(cf, A = X[, c('comorbidities', 'age', 'female')])"
    lines = [
        "",
        "Best linear projection of the conditional average treatment effect.",
        "Confidence intervals are cluster- and heteroskedasticity-robust (HC3):",
        "",
        "                 Estimate  Std. Error  t value  Pr(>|t|)",
        "(Intercept)       0.4218      0.3841    1.10    0.2726",
        "comorbidities    -0.7634      0.1152   -6.63   3.8e-11 ***",
        "age              -0.0183      0.0058   -3.16    0.0016 **",
        "female           -0.1247      0.1893   -0.66    0.5105",
    ]

    text = header + "\n" + "\n".join(lines)
    ax.text(0.02, 0.98, text, transform=ax.transAxes,
            fontsize=9, fontfamily='monospace', va='top', ha='left',
            color=NAVY,
            bbox=dict(boxstyle='round,pad=0.4', facecolor='#F8F8F8',
                     edgecolor='#CCCCCC', linewidth=1))

    plt.tight_layout()
    plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/output-blp.png',
                dpi=200, bbox_inches='tight', facecolor='white')
    plt.close()
    print("Done: output-blp.png")


if __name__ == '__main__':
    make_calibration_output()
    make_varimp_output()
    make_blp_output()
    print("\nAll output examples generated!")
