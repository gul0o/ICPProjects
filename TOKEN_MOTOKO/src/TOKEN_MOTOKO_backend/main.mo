import Icrc1Ledger "canister:icrc1_ledger_canister";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import Result "mo:base/Result";
import Options "mo:base/Option";
import Blob "mo:base/Blob";
import Error "mo:base/Error";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

actor {

type Account = {
  owner : Principal;
subaccount : ?[Nat8];
};

type TransferArgs = {
  amount : Nat;
  toAccount : Account;
};

public shared ({caller}) func transfer(arg : TransferArgs) : async Result.Result<Icrc1Ledger.BlockIndex, Text> {
Debug.print(
  "Transferring"
  # debug_show(args.amount)
  # " token to account "
  # debug_show (args.toAccount)
);
};

let transferArgs : Icrc1Ledger.TransferArgs = {
  memo = null; 
  amount = args.amount;
  from_subaccount = null;
  fee = null;
  to = args.toAccount;
  created_at_time = null;
};

try {
  let transferResult = await Icrc1Ledger.icrc1_transfer(transferArgs);

  switch (transferResult) {
    case(#err(transferError)) {
      #err("Couldn't transfer funds:\n" # debug_show(transferError))
    };
 case (#Ok(blockIndex)) {return #ok blockIndex};
  };
} catch (error: Error) {
  #err("Reject message: " # Error.message(error))
};
};

