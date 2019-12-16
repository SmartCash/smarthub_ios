//
//  Proposal.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 17/10/18.
//  Copyright © 2018 Erick Vavretchek. All rights reserved.
//

import Foundation

struct ProposalDetailsGetAPI: Decodable {
  let status: String
  let result: ProposalDetails
}

struct ProposalDetails: Decodable {
  let id: Int
  let key: String
  let title: String
  let url: String
  let summary: String
  let description: String
  let status: String
  let owner: String
  let createdDate: String
  let votingDeadline: String
  let voteYes: Double
  let voteNo: Double
  let voteAbstain: Double
  let percentYes: Double
  let percentNo: Double
  let percentAbstain: Double
  let amountSMART: Double
  let amountBTC: Double
  let amountUSD: Double
  
  enum CodingKeys: String, CodingKey {
    case id = "proposalId"
    case key = "proposalKey"
    case title
    case url
    case summary
    case description
    case status
    case owner
    case createdDate
    case votingDeadline
    case voteYes
    case voteNo
    case voteAbstain
    case percentYes
    case percentNo
    case percentAbstain
    case amountSMART = "amountSmart"
    case amountBTC = "amountBtc"
    case amountUSD
  }
  
  init (from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    key = try container.decode(String.self, forKey: .key)
    title = try container.decode(String.self, forKey: .title)
    url = try container.decode(String.self, forKey: .url)
    summary = try container.decode(String.self, forKey: .summary)
    description = try container.decode(String.self, forKey: .description)
    status = try container.decode(String.self, forKey: .status)
    owner = try container.decode(String.self, forKey: .owner)
    createdDate = try container.decode(String.self, forKey: .createdDate)
    votingDeadline = try container.decode(String.self, forKey: .votingDeadline)
    voteYes = try container.decode(Double.self, forKey: .voteYes)
    voteNo = try container.decode(Double.self, forKey: .voteNo)
    voteAbstain = try container.decode(Double.self, forKey: .voteAbstain)
    percentYes = (try? container.decode(Double.self, forKey: .percentYes)) ?? 0
    percentNo = (try? container.decode(Double.self, forKey: .percentNo)) ?? 0
    percentAbstain = (try? container.decode(Double.self, forKey: .percentAbstain)) ?? 0
    amountSMART = try container.decode(Double.self, forKey: .amountSMART)
    amountBTC = try container.decode(Double.self, forKey: .amountBTC)
    amountUSD = try container.decode(Double.self, forKey: .amountUSD)
  }
}
