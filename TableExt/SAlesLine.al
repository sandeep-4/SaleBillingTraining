tableextension 60005 SalesLineExt extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here

        field(60001; "Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60002; "Training"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                PurchPay: Record "Purchases & Payables Setup";
                Item: Record Item;
            begin
                if Type = Type::Item then begin
                    Item.Get("No.");
                    "Tax Amount" := (Item."Bill Amount" * (PurchPay."Bill Tax %" / 100) + Item."Bill Amount") * Quantity;
                end;
            end;
        }
    }

    var
        myInt: Integer;
}