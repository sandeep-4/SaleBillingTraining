codeunit 60001 "Bill Management"
{
    trigger OnRun()
    begin

    end;

    procedure PostBillToPostedBill(BillCode: Code[20])
    var
        BillHeader: Record "Billing Header";
        BillLine: Record "Billing Line";
        PostedBillHeader: Record "Posted Billing Header";
        PostedBillLine: Record "Posted Billing Line";
        LocalAmtAfterTax: Decimal;
        totalAmount: Decimal;
        PurchAndRec: Record "Purchases & Payables Setup";
        Vendor: Record Vendor;

    begin
        if not checkIfUserCanPostBill then
            Error('Acess Denied');
        PurchAndRec.Get();
        if BillHeader.Get(BillCode) then begin
            BillHeader.TestField("Sell to Customer"); //checks if the Customer No filed is blank or not
            if BillHeader.Type = BillHeader.Type::" " then
                Error('Type is mandatory to seclect before posting.');
            PostedBillHeader.Init(); //posting header
            PostedBillHeader.TransferFields(BillHeader);
            PostedBillHeader.Type := BillHeader.Type; //since the No prpety dont macth transgferfiled wont work
            PostedBillHeader.Posted := true;
            PostedBillHeader.Insert(true); //difference to be noted while using true 

            PostedBillHeader."Recived By" := BillHeader."Recived By";
            if Vendor.get(BillHeader."Vendor No.") then
                PostedBillHeader."Vendor Name" := Vendor.Name;
            PostedBillHeader.Modify(); //it is not necessay but done just to show it can be done this way


            //posting lines
            Clear(totalAmount);
            // totalAmount := 0; //it your choice
            BillLine.Reset();
            BillLine.SetRange("Document No.", BillHeader."No.");
            if BillLine.FindSet() then
                repeat
                    PostedBillLine.Init();
                    PostedBillLine.TransferFields(BillLine);
                    TaxCalculation(LocalAmtAfterTax, BillLine."Line Total");
                    PostedBillLine."Amount After Tax" := LocalAmtAfterTax;
                    PostedBillLine.Insert();

                    insertIntoBillLedger(BillLine, LocalAmtAfterTax);  //inserting into ledger
                    totalAmount += BillLine."Line Total";
                until BillLine.Next() = 0;

            PostedBillHeader."Total Amount" := totalAmount;
            PostedBillHeader."Amouont After Tax" := totalAmount + (totalAmount * (PurchAndRec."Bill Tax %"));
            PostedBillHeader.Modify();
            BillLine.DeleteAll();
            BillHeader.Delete(true);

        end;
    end;

    procedure TaxCalculation(var AmtAftTax: Decimal; lineAmt: Decimal)
    var
        PurchAndPay: Record "Purchases & Payables Setup";
    begin
        PurchAndPay.Get();
        AmtAftTax := (PurchAndPay."Bill Tax %" / 100) * lineAmt + lineAmt;
    end;

    local procedure insertIntoBillLedger(BillLine: Record "Billing Line"; taxAmt: Decimal)
    var
        BillLedger: Record "Bill Ledger Entry";
        BillHeader: Record "Billing Header";

    begin
        BillLedger.Init();
        if BillLedger.FindLast() then
            BillLedger."Entry No." += 1
        else
            BillLedger."Entry No." := 1;
        BillLedger."Document No." := BillLine."Document No.";
        BillLedger."Item No." := BillLine."Item No.";
        BillLedger."Line Total" := taxAmt;
        BillLedger.Quantity := BillLine.Quantity;
        BillLedger."Customer No." := getCustomerNoFromBillHeader(BillLine."Document No.");
        // BillLedger."Customer No." := BillLine.
        BillLedger.Insert();
    end;


    local procedure getCustomerNoFromBillHeader(DocNo: code[20]): Code[20]
    var
        BillHeader: Record "Billing Header";
    begin
        if BillHeader.Get(DocNo) then
            exit(BillHeader."Sell to Customer");
    end;

    procedure checkIfUserCanPostBill(): Boolean
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        if UserSetup."Allow Bill Post" then
            exit(true)
        else
            exit(false);
    end;


    procedure postItemWiseBill(BillHdr: Record "Billing Header")
    var
        tempBillLine: Record "Billing Line" temporary;
        tempBillHeader: Record "Billing Header" temporary;
        billLine: Record "Billing Line";
        billLine2: Record "Billing Line";
        tempBillHdr: Record "Billing Header" temporary;
        tempItem: Record Item temporary;
        PostedBillHeader: Record "Posted Billing Header";
        PostedBillLine: Record "Posted Billing Line";
        taxAmt: Decimal;
    begin
        BillHdr.Reset();
        BillHdr.TestField(Type);
        billLine.SetRange("Document No.", BillHdr."No.");
        if billLine.FindSet() then
            repeat
                tempItem.Init();
                tempItem."No." := billLine."Item No.";
                if tempItem.Insert() then; //inserts only uique
            until billLine.Next() = 0;

        if tempItem.FindSet() then
            repeat
                //   tempBillHdr.Init();
                //tempBillHdr := BillHdr;
                //  tempBillHdr."No." := InsStr(Format(tempItem), 'a', 1);
                // BillHdr.Modify();

                billLine2.Reset();
                billLine2.SetRange("Document No.", BillHdr."No.");
                billLine2.SetRange("Item No.", tempItem."No.");
                if billLine2.FindSet() then
                    repeat
                        tempBillLine.Init();
                        tempBillLine := billLine2;
                        if tempBillLine.Insert() then;
                    until billLine2.Next() = 0;
            // Message(Format(tempBillLine."Item No."));


            //  Message(Format(tempItem."No."));

            until tempItem.Next() = 0;


        //post
        if tempBillLine.FindSet() then
            repeat
                PostedBillHeader.Init();
                PostedBillHeader.TransferFields(BillHdr);
                PostedBillHeader."No." := CopyStr('Split' + (FORMAT(Random(9999))), 1, 19);
                PostedBillHeader.Type := BillHdr.Type;
                PostedBillHeader.Insert();
                PostedBillLine.Init();
                PostedBillLine."Document No." := PostedBillHeader."No.";
                PostedBillLine."Item No." := tempBillLine."Item No.";
                PostedBillLine.Description := tempBillLine.Description;
                PostedBillLine."Line Total" := tempBillLine."Line Total";
                TaxCalculation(taxAmt, tempBillLine."Line Total");
                PostedBillLine."Amount After Tax" := taxAmt;
                PostedBillLine.Insert();
            //  Message(Format(tempBillLine."Item No."));
            until tempBillLine.Next() = 0;

        Clear(tempItem);
        Clear(tempBillHdr);
        Clear(tempBillLine);

        billLine.Reset();
        billLine.SetRange("Document No.", BillHdr."No.");
        if billLine.FindSet() then
            repeat
                billLine.Delete();
            until billLine.Next() = 0;
        BillHdr.Delete();

    end;

    procedure postBillWiseBill(BillHdr: Record "Billing Header")
    var
        tempBillLine: Record "Billing Line" temporary;
        tempBillHeader: Record "Billing Header" temporary;
        billLine: Record "Billing Line";
        billLine2: Record "Billing Line";
        tempBillHdr: Record "Billing Header" temporary;
        tempItem: Record Item temporary;
        PostedBillHeader: Record "Posted Billing Header";
        PostedBillLine: Record "Posted Billing Line";
        taxAmt: Decimal;
    begin
        BillHdr.Reset();
        BillHdr.TestField(Type);
        BillHdr.Reset();
        if BillHdr.FindFirst() then begin
            billLine2.Reset();
            billLine2.SetRange("Document No.", BillHdr."No.");
            if billLine2.FindSet() then
                repeat
                    tempBillLine.Init();
                    tempBillLine := billLine2;
                    if tempBillLine.Insert() then;
                until billLine2.Next() = 0;
        end;
        //post
        if tempBillLine.FindSet() then
            repeat
                PostedBillHeader.Init();
                PostedBillHeader.TransferFields(BillHdr);
                PostedBillHeader."No." := CopyStr('Split' + (FORMAT(Random(9999))), 1, 19);
                PostedBillHeader.Insert();
                PostedBillLine.Init();
                PostedBillLine."Document No." := PostedBillHeader."No.";
                PostedBillLine."Item No." := tempBillLine."Item No.";
                PostedBillLine.Description := tempBillLine.Description;
                PostedBillLine."Line Total" := tempBillLine."Line Total";
                TaxCalculation(taxAmt, tempBillLine."Line Total");
                PostedBillLine."Amount After Tax" := taxAmt;
                PostedBillLine.Insert();
                Message(Format(tempBillLine."Item No."));
            until tempBillLine.Next() = 0;

        Clear(tempItem);
        Clear(tempBillHdr);
        Clear(tempBillLine);



    end;


    var
        myInt: Integer;
}