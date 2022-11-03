table 60001 "Posted Billing Header"
{
    Caption = 'Posted Billing Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(3; "User ID"; Code[20])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
        }
        field(4; "Sell to Customer"; Code[20])
        {
            Caption = 'Sell to Customer';
            DataClassification = ToBeClassified;
        }
        field(5; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
        }
        field(6; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(77; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = ToBeClassified;
        }
        field(27; "Recived By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(99; "Amouont After Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(109; Type; Option)
        {
            OptionMembers = " ",Customer,Employee;
        }
        field(110; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(111; "Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }


}
