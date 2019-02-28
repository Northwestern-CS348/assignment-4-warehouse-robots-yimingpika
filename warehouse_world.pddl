(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?l1 - location ?l2 - location ?r - robot)
      :precondition (and (no-robot ?l2) (at ?r ?l1) (connected ?l1 ?l2))
      :effect (and (no-robot ?l1) (at ?r ?l2) (not (no-robot ?l2)) (not(at ?r ?l1)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?l1 - location ?l2 - location ?r - robot ?p - pallette)
      :precondition (and (no-robot ?l2) (no-pallette ?l2) (at ?r ?l1) (at ?p ?l1) (connected ?l1 ?l2))
      :effect (and (no-robot ?l1) (no-pallette ?l1) (at ?r ?l2) (at ?p ?l2) (has ?r ?p) (not (no-robot ?l2)) (not (at ?p ?l1)) (not (at ?r ?l1)) (not (no-pallette ?l2)))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (packing-at ?s ?l) (at ?p ?l) (contains ?p ?si) (started ?s) (not (complete ?s)) (orders ?o ?si) (ships ?s ?o))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (not (complete ?s)) (started ?s) (packing-at ?s ?l) (ships ?s ?o))
      :effect (and (complete ?s) (available ?l))
   )
)
