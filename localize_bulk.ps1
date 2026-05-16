# Bulk localization script for remaining screens
# This script adds AppLocalizations import and replaces hardcoded strings

$base = "d:\Flutter_Projects\ERP_Sales\erp_sales\lib"

# Helper function to add import if not already present
function Add-L10nImport {
    param([string]$file)
    $content = Get-Content $file -Raw
    if ($content -notmatch 'app_localizations') {
        $content = $content -replace "(import 'package:flutter/material.dart';)", "`$1`r`nimport 'package:erp_sales/l10n/app_localizations.dart';"
        Set-Content $file $content -NoNewline
    }
}

# List of remaining files to localize
$files = @(
    "$base\features\items\presentation\screens\items_screen.dart",
    "$base\features\items\presentation\screens\item_details_screen.dart",
    "$base\features\items\presentation\screens\create_item_screen.dart",
    "$base\features\items\presentation\screens\create_stock_entry_screen.dart",
    "$base\features\sales_orders\presentation\screens\sales_orders_screen.dart",
    "$base\features\sales_orders\presentation\screens\sales_order_details_screen.dart",
    "$base\features\sales_orders\presentation\screens\sales_invoice_screen.dart",
    "$base\features\sales_orders\presentation\screens\sales_invoice_details_screen.dart",
    "$base\features\sales_orders\presentation\screens\sales_invoice_view.dart",
    "$base\features\sales_orders\presentation\screens\delivery_notes_screen.dart",
    "$base\features\sales_orders\presentation\screens\delivery_note_details_screen.dart",
    "$base\features\auth\presentation\screens\admin_home_screen.dart",
    "$base\features\auth\presentation\screens\sales_home_screen.dart",
    "$base\features\auth\presentation\screens\hr_home_screen.dart",
    "$base\features\auth\presentation\screens\customer_home_screen.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Add-L10nImport $file
        Write-Host "Added import to: $file"
    } else {
        Write-Host "File not found: $file"
    }
}

Write-Host "`nDone adding imports to all remaining files."
