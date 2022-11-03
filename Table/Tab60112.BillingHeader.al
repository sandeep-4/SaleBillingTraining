table 60112 "Billing Header"
{
    Caption = 'Billing Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            // NotBlank = true;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    Purchase.Get();
                    Purchase.TestField("Header No.");
                    NoSeriesMgmt.TestManual(Purchase."Header No.");
                    Description := '';
                    NoSeriesMgmt.SetSeries("No.");
                end;
            end;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "User ID"; Code[20])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;

        }
        field(4; "Sell to Customer"; Code[20])
        {
            Caption = 'Sell to Customer/Employee';
            DataClassification = ToBeClassified;
            TableRelation = if (Type = const(Customer)) Customer
            else
            if (Type = const(Employee)) Employee;

            trigger OnValidate()
            var
                Customer: Record Customer;
                Employee: Record Employee;
                BillLine: Record "Billing Line";
            begin
                TestField(Type);
                if Type = Type::Customer then begin
                    if Customer.Get("Sell to Customer") then begin
                        Address := Customer.Address;
                        "Customer Name" := Customer.Name;
                    end else begin
                        //Clear(Address);
                        Address := '';
                    end;
                end else
                    if Type = Type::Employee then begin
                        if Employee.Get("Sell to Customer") then begin
                            Address := Employee.Address;
                            "Customer Name" := Employee.FullName();
                        end else begin
                            Address := '';
                            "Customer Name" := '';
                        end;
                    end;
                BillLine.Reset();
                BillLine.SetRange("Document No.", "No.");
                if BillLine.FindSet() then
                    repeat
                        BillLine."Cust No." := "Sell to Customer";
                        BillLine.Modify();
                    until BillLine.Next() = 0;
            end;
        }
        field(8; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            //  FieldClass = FlowField;
            //   CalcFormula = lookup(Customer.Name where("No." = field("Sell to Customer")));
            Editable = false;

        }
        field(5; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Billing Line"."Line Total" where("Document No." = field("No.")));
            Editable = false;

        }
        field(7; Description; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(17; "Recived By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(19; "Type"; Option)
        {
            // DataClassification = ToBeClassified;
            OptionMembers = " ",Customer,Employee;
        }

        field(21; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }

        field(22; "Time Filed"; Time)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Text Time" := updateTimeToText("Time Filed");
            end;
        }

        field(23; "Text Time"; TExt[50])
        {
            DataClassification = ToBeClassified;
        }

        field(24; TimeDecimal; Decimal)
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

    var
        Purchase: Record "Purchases & Payables Setup";
        // Item: Record Item;
        NoSeriesMgmt: Codeunit NoSeriesManagement;
    // Item: Record Item;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            Purchase.Get();
            Purchase.TestField("Header No.");
            Clear(NoSeriesMgmt);
            NoSeriesMgmt.InitSeries(Purchase."Header No.", xRec.Description, Today, "No.", rec.Description);
        end;
        "Posting Date" := Today;
        "User ID" := CopyStr(UserId, 1, 20);
    end;

    trigger OnDelete()
    var
        myInt: Integer;
    begin

    end;


    procedure updateTimeToText(timeP: Time) timeR: text
    var
        times: array[3] of Decimal;
        timetext: Text;
        time2Text: text;
        time3Text: text;
    begin
        if timeP = 0T then
            exit;

        timetext := Format(timeP);
        Evaluate(times[1], CopyStr(timetext, 1, 2));
        Evaluate(times[2], CopyStr(timetext, 4, 2));
        Evaluate(times[3], CopyStr(timetext, 7, 2));

        if CopyStr(timetext, 10, 2) = 'PM' then
            times[1] += 12;

        if times[2] / 10 < 1 then
            time2Text := '0' + format(times[2])
        else
            time2Text := format(times[2]);

        if times[3] / 10 < 1 then
            time3Text := '0' + format(times[3])
        else
            time3Text := format(times[3]);

        timeR := format(times[1]) + ':' + time2Text + ':' + time3Text;

    end;

}
