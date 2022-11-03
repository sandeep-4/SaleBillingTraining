table 60002 "Posted Billing Line"
{
    Caption = 'Billing Line';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            // TableRelation = "Billing Header"."No.";
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
        }

        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                TotalPrice: Decimal;
                BillingHeader: Record "Billing Header";
            begin

            end;
        }
        field(6; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = lookup(Item."Unit Price" where("No." = field("Item No.")));

        }
        field(7; "Line Total"; Decimal)
        {
            Caption = 'Line Total';
            DataClassification = ToBeClassified;

        }

        field(21; "Amount After Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
